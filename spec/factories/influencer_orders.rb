# this factory can only be built with an influencer passed in
FactoryBot.define do
  factory :influencer_order do
    name 'TEST_ORDER_ONE'
    shipping_address(
      { "zip" => "12345",
        "city" => "Miami",
        "phone" => nil,
        "address1" => "2468 First St.",
        "address2" => "Unit 404",
        "last_name" => "LastName",
        "first_name" => "FirstName",
        "country_code" => "US",
        "province_code" => "FL" }
    )
    billing_address(
      { "zip" => "12345",
        "city" => "Miami",
        "name" => "FirstName LastName",
        "phone" => nil,
        "address1" => "2468 First St.",
        "address2" => "Unit 404",
        "country_code" => "US",
        "province_code" => "FL" }
    )

    line_item(
      { "size" => "ONE SIZE",
        "item_name" => "350ml Rose Gold Bottle",
        "product_id" => 8993522642,
        "sell_price" => 0.0,
        "product_weight" => 0,
        "merchant_sku_item" => "722457740444",
        "quantity_requested" => 1 }
    )
  end
end
