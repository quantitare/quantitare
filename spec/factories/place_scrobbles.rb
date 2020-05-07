# frozen_string_literal: true

FactoryBot.define do
  factory :place_scrobble do
    user
    name { Faker::Lorem.words(number: rand(5)).join(' ') }
    category { Faker::Lorem.words(number: 1).join(' ') }
    source { create :location_import }
    trackpoints { [{ latitude: 1.0, longitude: 1.0, timestamp: Time.current }] }

    start_time { 2.hours.ago }
    end_time { 1.hour.ago }
  end
end
