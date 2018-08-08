# frozen_string_literal: true

FactoryBot.define do
  factory :location_import do
    user
    adapter 'GoogleMapsKmlAdapter'
  end
end
