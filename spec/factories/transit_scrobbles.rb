# frozen_string_literal: true

FactoryBot.define do
  factory :transit_scrobble do
    user
    category { Faker::Lorem.words(number: 1) }
    source { create :location_import }

    start_time { 2.hours.ago }
    end_time { 1.hour.ago }
  end
end
