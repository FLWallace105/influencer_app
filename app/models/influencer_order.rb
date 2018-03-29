class InfluencerOrder < ApplicationRecord
  belongs_to :influencer
  has_one(:tracking, class_name: 'InfluencerTracking', foreign_key: 'order_name',
                     primary_key: 'name')

   ORDER_NUMBER_CHARACTERS = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a].flatten.to_a.freeze

   def self.generate_order_number(prefix: '#IN')
     prefix + (0..9).map{ORDER_NUMBER_CHARACTERS.sample}.join
   end

  def self.create_from_influencer_variant(influencer:, variant:, shipping_method_requested:, shipping_lines:, order_number:)
    # shipping lines blank most of the time
    create(
      name: order_number || generate_order_number,
      processed_at: Time.current,
      billing_address: influencer.billing_address,
      shipping_address: influencer.shipping_address,
      shipping_lines: shipping_lines,
      line_item: variant_line_item(variant),
      influencer_id: influencer.id,
      shipment_method_requested: shipping_method_requested
    )
  end

  def self.variant_line_item(variant, quantity = 1)
    {
      'product_id' => variant.product_id,
      'merchant_sku_item' => variant.sku,
      'size' => variant.option1,
      'quantity_requested' => quantity,
      'item_name' => variant.product.title,
      'sell_price' => variant.price,
      'product_weight' => variant.weight
    }
  end
end
