# frozen_string_literal: true

FactoryBot.define do
  factory :place_match do
    user
    source { create :location_import }
    place

    source_fields { { longitude: Faker::Address.longitude, latitude: Faker::Address.latitude } }
  end
end
