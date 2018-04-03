class Influencer < ApplicationRecord
  has_many :orders, class_name: 'InfluencerOrder'
  has_many :tracking_info, class_name: 'InfluencerTracking'

  validates_presence_of :first_name
  validates_presence_of :last_name
  validates_presence_of :address1
  validates_presence_of :city
  validates_presence_of :collection_id
  validates_presence_of :email
  after_save :touch

  def self.assign_from_row(row)
    influencer = find_or_initialize_by(email: row[:email])
    influencer.assign_attributes(
      row.to_hash.slice(
        :first_name, :last_name, :address1, :address2, :city, :state, :zip,
        :phone, :bra_size, :top_size, :bottom_size, :sports_jacket_size,
        :shipping_method_requested, :collection_id
      )
    )
    influencer
  end

  def sized_variants_from_collection
    product_ids = Collect.where(collection_id: collection_id).pluck(:product_id)
    variants = ProductVariant.where(product_id: product_ids)

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
end
