FactoryBot.define do
  factory :influencer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr}
    zip { Faker::Address.zip }
    email { Faker::Internet.email }
    bra_size ['XS', 'S', 'M', 'L', 'XL'].sample
    top_size ['XS', 'S', 'M', 'L', 'XL'].sample
    bottom_size ['XS', 'S', 'M', 'L', 'XL'].sample
    sports_jacket_size ['XS', 'S', 'M', 'L', 'XL'].sample
    active true

    trait :with_order do
      after(:create) do |influencer|
        create(
          :influencer_order, shipping_address: influencer.shipping_address,
                             billing_address: influencer.billing_address,
                             influencer: influencer
        )
      end
    end

    # FactoryBot saves the order_name variable when the factory is loaded, therefore
    # when I want to test more than one influencer with a with_three_product_order
    # they will have the same order_name which is not supposed to happen.
    # the quick fix is to create different traits so it will save two different
    # order_names
    trait :with_three_product_order do
      order_name = InfluencerOrder.generate_order_number
      after(:create) do |influencer|
        3.times do
          create(
            :influencer_order, shipping_address: influencer.shipping_address,
                               billing_address: influencer.billing_address,
                               influencer: influencer,
                               name: order_name
          )
        end
      end
    end

    trait :with_different_three_product_order do
      order_name = InfluencerOrder.generate_order_number
      after(:create) do |influencer|
        3.times do
          create(
            :influencer_order, shipping_address: influencer.shipping_address,
                               billing_address: influencer.billing_address,
                               influencer: influencer,
                               name: order_name
          )
        end
      end
    end

    trait :with_collection do
      after(:build) do |influencer|
        custom_collection = create(:custom_collection, :with_three_products)
        influencer.collection_id = custom_collection.id
      end
    end
  end
end
