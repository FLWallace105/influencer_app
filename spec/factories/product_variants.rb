FactoryBot.define do
  factory :product_variant do
    id { Faker::Number.number(10) }
    trait :xs do
      option1 'XS'
    end

    trait :s do
      option1 'S'
    end

    trait :m do
      option1 'M'
    end

    trait :l do
      option1 'L'
    end

    trait :xl do
      option1 'XL'
    end

    trait :one_size do
      option1 'ONE SIZE'
    end
  end
end
