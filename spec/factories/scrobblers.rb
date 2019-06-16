# frozen_string_literal: true

FactoryBot.define do
  factory :scrobbler do
    user

    name { Faker::Lorem.words(1)[0] }
    type { 'Scrobblers::DummyScrobbler' }

    factory :webhook_scrobbler, class: Scrobblers::WebhookScrobbler
  end
end
