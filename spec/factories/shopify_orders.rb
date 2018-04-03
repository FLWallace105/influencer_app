FactoryBot.define do
  factory :shopify_order do
    id { Faker::Number.number(10) }
  end
end
