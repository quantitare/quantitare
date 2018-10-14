# frozen_string_literal: true

FactoryBot.define do
  factory :place_match do
    user
    source { create :location_import }
    place

    source_fields { { longitude: Faker::Address.longitude.to_s, latitude: Faker::Address.latitude.to_s } }
  end
end
