# frozen_string_literal: true

FactoryBot.define do
  factory :place_match do
    user
    source { create :location_import }
    place

    source_field_radius { 250 }
    source_field_latitude { Faker::Address.latitude }
    source_field_longitude { Faker::Address.longitude }

    trait :name_only do
      source_field_name { Faker::Lorem.word }
      source_field_radius { nil }
      source_field_latitude { nil }
      source_field_longitude { nil }
    end
  end
end
