class Influencer < ApplicationRecord
  has_many :orders, class_name: 'InfluencerOrder'
  has_many :tracking_info, class_name: 'InfluencerTracking'

  def self.import(file)
    counter = 0
    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|
      influencer = Influencer.assign_from_row(row)
      collection_id = row[:collection_id]

      if collection_id.try(:strip).try(:present?) && influencer.save
        counter += 1
        orders = influencer.create_orders_from_collection(
          collection_id: collection_id,
          shipping_method_requested: row[:shipping_method_requested]
        )

        puts "created #{orders.count} orders for #{influencer.first_name} #{influencer.last_name}"
      else
        puts "#{influencer.emal} - #{influencer.errors.full_messages.join(',')}"
      end
    end
    counter
  end

  def self.assign_from_row(row)
    influencer = find_or_initialize_by(email: row[:email])
    influencer.assign_attributes(
      row.to_hash.slice(
        :first_name, :last_name, :address1, :address2, :city, :state, :zip,
        :phone, :bra_size, :top_size, :bottom_size,
        :sports_jacket_size
      )
    )
    influencer
  end

  # shipping_lines are to override the default shipping line data
  def create_orders_from_collection(collection_id:, shipping_method_requested: nil, shipping_lines: nil)
    sized_variants = sized_variants_from_collection(collection_id)
    order_number = InfluencerOrder.generate_order_number
    sized_variants.map do |variant|
      InfluencerOrder.create_from_influencer_variant(
        influencer: self,
        variant: variant,
        shipping_method_requested: shipping_method_requested,
        shipping_lines: shipping_lines,
        order_number: order_number
      )
    end
  end

  def sized_variants_from_collection(collection_id)
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
      'Jacket' => sports_jacket_size,
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
      'phone' => phone,
    }
  end

  def billing_address
    address.merge('name' => "#{first_name} #{last_name}")
  end

  def shipping_address
    address.merge(
      'first_name' => first_name,
      'last_name' => last_name,
    )
  end
end
