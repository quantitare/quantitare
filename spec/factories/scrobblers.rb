# frozen_string_literal: true

FactoryBot.define do
  factory :scrobbler do
    user

    name { Faker::Lorem.words(1)[0] }
    type { 'Scrobblers::DummyScrobbler' }

    factory :webhook_scrobbler, class: Scrobblers::WebhookScrobbler
    factory :withings_scrobbler, class: Scrobblers::WithingsScrobbler do
      type { 'Scrobblers::WithingsScrobbler' }
      service { create :service, :withings2 }
      options { { categories: Scrobblers::WithingsScrobbler::CATEGORIES } }
    end
  end
end
