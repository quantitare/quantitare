# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    user
    provider { Faker::Lorem.words(1) }
    name { Faker::Lorem.words(1) }
    token { SecureRandom.hex }

    trait :with_secret do
      secret { SecureRandom.hex }
    end
  end
end
