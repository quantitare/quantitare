# frozen_string_literal: true

FactoryBot.define do
  factory :place_match do
    user
    source { create :location_import }
    place

    source_fields { { name: Faker::Lorem.words(2).join(' ') } }
  end
end
