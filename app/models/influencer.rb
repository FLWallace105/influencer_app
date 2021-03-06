class Influencer < ApplicationRecord
  include StatesHelper

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
  validate :address2_comma
  validate :city_field_comma
  validate :check_states_field
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
    trim_sizes(influencer)
    fix_states_field(influencer)
    puts "Now influencer = #{influencer.inspect}"
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
      'sports-jacket' => sports_jacket_size
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

  def self.trim_sizes(influencer)
    #influencer.bra_size.try(:gsub(/\s+/, ""))
    (influencer.bra_size || "").gsub(/\s+/, "")
    (influencer.top_size || "").gsub(/\s+/, "")
    (influencer.bottom_size || "").gsub(/\s+/, "")
    (influencer.sports_jacket_size || "").gsub(/\s+/, "")
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

  def self.fix_states_field(influencer)
    #puts "I am here"
    temp_state = influencer.state
    if !temp_state.nil?
    
    state_field_length = temp_state.length

    if state_field_length > 2
      #puts "state_field_length = #{state_field_length}"
      puts "long state name = #{influencer.state}"
      real_state_abbreviation = States.key(influencer.state)
      puts "real_state_abbreviation = #{real_state_abbreviation}"
      if !real_state_abbreviation.nil?
        influencer.state = real_state_abbreviation
        return
      else
        #errors.add(:base, "cannot find Valid State Full Name State: #{influencer.state}")
        return
      end

    end

    else
      puts "Nil value for State"
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
    if !address1.nil? && address1 != ""
      temp_address1 = address1.downcase

      if temp_address1.match(/\sapt\s|#|\sste\s|\ssuite\s|\sapartment\s|\sunit\s|,/i)
        errors.add(:base, "Cannot have Apt/Suite/Ste/# OR comma (,) in Address1 field")
      else
        return
      end
    else
      return
    end

  end

  def address2_comma
    if !address2.nil? && address2 != ""
      temp_address2 = address2.downcase

      if temp_address2.match(/,/i)
        errors.add(:base, "Cannot have comma (,) in Address2 field")
      else
        return
      end
    else
      return
    end

  end

  def city_field_comma
    if !city.nil? && city != ""
      temp_city = city
      if temp_city.match(/,/i)
        errors.add(:base, "Cannot have comma (,) in City Field")
      else
        return
      end
    else
      return
    end


  end


  def check_states_field
    #framework here for checking error conditions
    if !state.nil?
      state_field_length = state.length
    
      if state_field_length == 2
        if !States.has_key?(state.to_sym)
          errors.add(:base, "cannot find Valid State Abbreviation two letter code for state: #{state}")
        end
      elsif state_field_length > 2
        puts "long state name = #{state}"
        real_state_abbreviation = States.key(state)
        if real_state_abbreviation.nil?
          errors.add(:base, "cannot find Valid State Full Name State: #{state}")
        end
      else
        #state is either 1 long
        errors.add(:base, "State Field Cannot have just one character")
      end
    else
      errors.add(:base, "State Field Cannot be blank")
    end
  end

end
