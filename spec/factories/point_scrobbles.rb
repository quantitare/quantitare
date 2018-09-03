# frozen_string_literal: true

FactoryBot.define do
  factory :point_scrobble do
    user
    category { Faker::Lorem.words(1) }
    source { create :scrobbler }

    timestamp { 1.hour.ago }
  end
end
