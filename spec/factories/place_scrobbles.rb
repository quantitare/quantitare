# frozen_string_literal: true

FactoryBot.define do
  factory :place_scrobble do
    user
    category { Faker::Lorem.words(1) }
    source { create :location_import }
    trackpoints { [{ latitude: 1, longitude: 1, timestamp: Time.current }] }

    start_time { 2.hours.ago }
    end_time { 1.hour.ago }
  end
end
