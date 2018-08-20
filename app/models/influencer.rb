class Influencer < ApplicationRecord
  has_many :orders, class_name: 'InfluencerOrder'
  has_many :tracking_info, class_name: 'InfluencerTracking'

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :state
  validates_presence_of :zip
  validates_presence_of :email
  validates_inclusion_of :bra_size, :in => ['XS', 'S', 'M', 'L', 'XL']
  validates_inclusion_of :top_size, :in => ['XS', 'S', 'M', 'L', 'XL']
  validates_inclusion_of :bottom_size, :in => ['XS', 'S', 'M', 'L', 'XL']
  validates_inclusion_of :sports_jacket_size, :in => ['XS', 'S', 'M', 'L', 'XL']
  validates_presence_of :collection_id
  validates_inclusion_of :active, in: [true, false]
  validates_uniqueness_of :email
  validates :email, email: true
  validate :unique_shipping_address
  validate :address2_apartment
  after_save :touch
  strip_attributes

  def self.assign_from_row(row)
    influencer = find_or_initialize_by(email: row[:email])
    influencer.assign_attributes(
      row.to_hash.slice(
        :first_name, :last_name, :address1, :address2, :city, :state, :zip,
        :phone, :bra_size, :top_size, :bottom_size, :sports_jacket_size,
        :shipping_method_requested, :collection_id
      )
    )
    upcase_sizes(influencer)
    influencer
  end

  def sized_variants_from_collection
    product_ids = Collect.where(collection_id: collection_id).pluck(:product_id)
    variants = ProductVariant.where(product_id: product_ids).includes(:product)

    variants.select do |variant|
      variant.size == 'ONE SIZE' || variant.size == sizes[variant.product.product_type]
    end
  end

  def sizes
    {
      'Leggings' => bottom_size,
      'Tops' => top_size,
      'Sports Bra' => bra_size,
      'Jacket' => sports_jacket_size
    }
  end

  def address
    {
      'address1' => address1,
      'address2' => address2,
      'city' => city,
      'zip' => zip,
      'province_code' => state,
      'country_code' => 'US',
      'phone' => phone
    }
  end

  def billing_address
    address.merge('name' => "#{first_name} #{last_name}")
  end

  def shipping_address
    address.merge(
      'first_name' => first_name,
      'last_name' => last_name
    )
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.upcase_sizes(influencer)
    influencer.bra_size.try(:upcase!)
    influencer.top_size.try(:upcase!)
    influencer.bottom_size.try(:upcase!)
    influencer.sports_jacket_size.try(:upcase!)
  end

  def self.search_by_email_or_name(search_term)
    where('email ILIKE ?', "%#{search_term}%")
      .or(where('last_name ILIKE ?', "%#{search_term}%"))
      .or(where('first_name ILIKE ?', "%#{search_term}%"))
      .or(where("first_name ILIKE ? AND last_name ILIKE ?",
                search_term.split(' ').first, search_term.split(' ').last))
  end

  def self.to_csv
    attributes = %w[first_name last_name address1 address2 city state zip email
                    phone bra_size top_size bottom_size sports_jacket_size
                    three_item shipping_method_requested collection_id active]
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |influencer|
        csv << influencer.attributes.values_at(*attributes)
      end
    end
  end

  private

  def unique_shipping_address
    matches = Influencer.all.select { |influencer| shipping_address == influencer.shipping_address}
    return if matches.size == 1 && persisted? && matches.first == Influencer.find(id) # must be updating the same influencer
    errors.add(:base, "Shipping address must be unique.") if matches.present?
  end

  def address2_apartment
    #validate address1 does not have pattern "202 E First, Apt. 22"
    temp_address1 = address1.downcase

    if temp_address1.match(/apt|#|ste|suite|unit|,/i)
      errors.add(:base, "Cannot have Apt/Suite/Ste/# OR comma (,) in Address1 field")
    else
      return
    end

  end


end
