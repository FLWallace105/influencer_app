class InfluencerOrder < ApplicationRecord
  belongs_to :influencer
  has_one(:tracking, class_name: 'InfluencerTracking', foreign_key: 'order_name',
                     primary_key: 'name')

  validates_presence_of :name
  validates_presence_of :shipping_address
  validates_presence_of :billing_address
  validates_presence_of :line_item

  before_save :set_influencer_full_name

   ORDER_NUMBER_CHARACTERS = [('a'..'z').to_a, ('A'..'Z').to_a, ('0'..'9').to_a].flatten.to_a.freeze

   def self.generate_order_number(prefix: '#IN')
     prefix + (0..9).map{ORDER_NUMBER_CHARACTERS.sample}.join
   end

  def self.new_from_influencer_variant(influencer:, variant:, shipping_method_requested:, order_number:, shipping_lines: nil)
    # Shipping_lines are to override the default shipping line data; they are blank most (all?) of the time.
    new(
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

  def self.name_csv
    # When manually testing prefix this string with TEST_
    "Orders_#{Time.current.strftime('%Y_%m_%d_%H_%M_%S_%L')}.csv"
  end

  CSV_DATE_FMT = '%m/%d/%Y %H:%M'.freeze
  CSV_HEADERS =
    [
      "order_number", "groupon_number", "order_date", "merchant_sku_item",
      "quantity_requested", "shipment_method_requested", "shipment_address_name",
      "shipment_address_street", "shipment_address_street_2",
      "shipment_address_city", "shipment_address_state",
      "shipment_address_postal_code", "shipment_address_country", "gift",
      "gift_message", "quantity_shipped", "shipment_carrier", "shipment_method",
      "shipment_tracking_number", "ship_date", "groupon_sku", "custom_field_value",
      "permalink", "item_name", "vendor_id", "salesforce_deal_option_id",
      "groupon_cost", "billing_address_name", "billing_address_street",
      "billing_address_city", "billing_address_state", "billing_address_postal_code",
      "billing_address_country", "purchase_order_number", "product_weight",
      "product_weight_unit", "product_length", "product_width", "product_height",
      "product_dimension_unit", "customer_phone", "incoterms", "hts_code",
      "3pl_name", "3pl_warehouse_location", "kitting_details", "sell_price",
      "deal_opportunity_id", "shipment_strategy", "fulfillment_method",
      "country_of_origin", "merchant_permalink", "feature_start_date",
      "feature_end_date", "bom_sku", "payment_method", "color_code", "tax_rate",
      "tax_price"
    ].freeze

  def self.create_csv(orders)
    filename = name_csv
    rows = orders.map(&:to_row_hash)
    clean_rows = rows.map { |row| row.map { |k, v| [k, Iconv.conv('ASCII//TRANSLIT', 'UTF-8', v.to_s)] }.to_h }
    puts "#{orders.length} Order line items"
    CSV.open(filename, 'a+', headers: CSV_HEADERS) do |csv|
      csv << CSV_HEADERS
      clean_rows.each { |data| csv << CSV_HEADERS.map { |key| data[key] } }
    end

    filename
  end

  def self.search_by_name_or_last_name(query)
    where('influencer_full_name ILIKE ?', "%#{query}%")
      .or(where('name ILIKE ?', "%#{query}%"))
  end

  def to_row_hash
    {
      'order_number' => name,
      'order_date' => processed_at.try(:strftime, CSV_DATE_FMT),
      'customer_phone' => billing_address["phone"].try('gsub', /[^0-9]/, ''),
      'sell_price' => line_item['sell_price'],
      'quantity_requested' => 1,
      'merchant_sku_item' => line_item['merchant_sku_item'],
      'product_weight' => line_item['product_weight'],
      'item_name' => line_item['item_name'],
      'billing_address_name' => billing_address["name"],
      'billing_address_street' => billing_address["address1"],
      'billing_address_city' => billing_address["city"],
      'billing_address_postal_code' => billing_address["zip"],
      'billing_address_state' => billing_address["province_code"],
      'billing_address_country' => billing_address["country_code"],
      'shipment_address_name' => "#{shipping_address['first_name']} #{shipping_address['last_name']}",
      'shipment_address_street' => shipping_address["address1"],
      'shipment_address_street_2' => shipping_address["address2"],
      'shipment_address_city' => shipping_address["city"],
      'shipment_address_postal_code' => shipping_address["zip"],
      'shipment_address_state' => shipping_address["province_code"],
      'shipment_address_country' => shipping_address["country_code"],
      'shipment_method_requested' => shipment_method_requested,
      'gift' => 'FALSE'
    }
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

  private

  def set_influencer_full_name
    self.influencer_full_name = influencer.full_name
  end
end
