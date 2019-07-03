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

    trait :withings2 do
      provider { :withings2 }
      token { ENV['WITHINGS_TEST_USER_TOKEN'] }
      refresh_token { ENV['WITHINGS_TEST_USER_REFRESH_TOKEN'] }
      options { { name: 'Withings' } }
    end

    trait :expired do
      expires_at { 24.hours.ago }
    end
  end
end
