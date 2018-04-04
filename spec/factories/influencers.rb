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
  end
end
