# frozen_string_literal: true

FactoryBot.define do
  factory :point_scrobble do
    user
    category { 'log' }
    source { create :scrobbler }

    timestamp { 1.hour.ago }

    data { { content: Faker::Lorem.sentence } }
  end
end
