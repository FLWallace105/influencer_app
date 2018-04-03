FactoryBot.define do
  factory :influencer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    address1 { Faker::Address.street_address }
    city { Faker::Address.city }
    email { Faker::Internet.email }
  end
end
