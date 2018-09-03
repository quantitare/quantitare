# frozen_string_literal: true

FactoryBot.define do
  factory :scrobbler do
    user

    name { Faker::Lorem.words(1) }
    type 'Scrobblers::DummyScrobbler'
  end
end
