FactoryBot.define do
  factory :custom_collection do
    id { Faker::Number.number(10) }

    trait :with_three_products do
      after(:create) do |custom_collection|
        product1 = FactoryBot.create(:product, :leggings)
        FactoryBot.create(:collect, collection: custom_collection, product: product1)
        FactoryBot.create(:product_variant, :xs, product: product1)
        FactoryBot.create(:product_variant, :s, product: product1)
        FactoryBot.create(:product_variant, :m, product: product1)
        FactoryBot.create(:product_variant, :l, product: product1)
        FactoryBot.create(:product_variant, :xl, product: product1)

        product2 = FactoryBot.create(:product, :tops)
        FactoryBot.create(:collect, collection: custom_collection, product: product2)
        FactoryBot.create(:product_variant, :xs, product: product2)
        FactoryBot.create(:product_variant, :s, product: product2)
        FactoryBot.create(:product_variant, :m, product: product2)
        FactoryBot.create(:product_variant, :l, product: product2)
        FactoryBot.create(:product_variant, :xl, product: product2)

        product3 = FactoryBot.create(:product, :sports_bra)
        FactoryBot.create(:collect, collection: custom_collection, product: product3)
        FactoryBot.create(:product_variant, :xs, product: product3)
        FactoryBot.create(:product_variant, :s, product: product3)
        FactoryBot.create(:product_variant, :m, product: product3)
        FactoryBot.create(:product_variant, :l, product: product3)
        FactoryBot.create(:product_variant, :xl, product: product3)
      end
    end

    trait :with_five_products do
      after(:create) do |custom_collection|
        product1 = FactoryBot.create(:product, :leggings)
        FactoryBot.create(:collect, collection: custom_collection, product: product1)
        FactoryBot.create(:product_variant, :xs, product: product1)
        FactoryBot.create(:product_variant, :s, product: product1)
        FactoryBot.create(:product_variant, :m, product: product1)
        FactoryBot.create(:product_variant, :l, product: product1)
        FactoryBot.create(:product_variant, :xl, product: product1)

        product2 = FactoryBot.create(:product, :tops)
        FactoryBot.create(:collect, collection: custom_collection, product: product2)
        FactoryBot.create(:product_variant, :xs, product: product2)
        FactoryBot.create(:product_variant, :s, product: product2)
        FactoryBot.create(:product_variant, :m, product: product2)
        FactoryBot.create(:product_variant, :l, product: product2)
        FactoryBot.create(:product_variant, :xl, product: product2)

        product3 = FactoryBot.create(:product, :sports_bra)
        FactoryBot.create(:collect, collection: custom_collection, product: product3)
        FactoryBot.create(:product_variant, :xs, product: product3)
        FactoryBot.create(:product_variant, :s, product: product3)
        FactoryBot.create(:product_variant, :m, product: product3)
        FactoryBot.create(:product_variant, :l, product: product3)
        FactoryBot.create(:product_variant, :xl, product: product3)

        product4 = FactoryBot.create(:product, :accessories)
        FactoryBot.create(:collect, collection: custom_collection, product: product4)
        FactoryBot.create(:product_variant, :one_size, product: product4)

        product5 = FactoryBot.create(:product, :accessories)
        FactoryBot.create(:collect, collection: custom_collection, product: product5)
        FactoryBot.create(:product_variant, :one_size, product: product5)
      end
    end
  end
end
