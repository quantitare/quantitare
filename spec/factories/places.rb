# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    user

    name { Faker::Lorem.words(number: 2).join(' ') }
    category { Faker::Lorem.words(number: 1).join(' ') }

    longitude { 37.8053204 }
    latitude { -122.27254440000002 }

    trait :starting_with_address do
      longitude { nil }
      latitude { nil }

      street_1 { '1 Frank H Ogawa Plaza' }
      city { 'Oakland' }
      state { 'CA' }
      zip { '94612' }
      country { 'United States' }
    end

    trait :with_service do
      service
    end
  end
end
