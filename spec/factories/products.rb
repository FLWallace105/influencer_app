FactoryBot.define do
  factory :product do
    id { Faker::Number.number(10) }
    trait :with_collection_and_variants do
      after(:create) do |product|
        custom_collection = create(:custom_collection)
        FactoryBot.create(:collect, collection: custom_collection, product: product )
        FactoryBot.create(:product_variant, :xs, product: product)
        FactoryBot.create(:product_variant, :s, product: product)
        FactoryBot.create(:product_variant, :m, product: product)
        FactoryBot.create(:product_variant, :l, product: product)
        FactoryBot.create(:product_variant, :xl, product: product)
      end
    end

    trait :leggings do
      product_type 'Leggings'
    end

    trait :tops do
      product_type 'Tops'
    end

    trait :sports_bra do
      product_type 'Sports Bra'
    end

    trait :jacket do
      product_type 'Jacket'
    end

    trait :accessories do
      product_type 'Accessories'
    end
  end
end
