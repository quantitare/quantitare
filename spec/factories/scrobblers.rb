# frozen_string_literal: true

FactoryBot.define do
  factory :scrobbler, class: Scrobblers::DummyScrobbler do
    user

    name { Faker::Lorem.words(1)[0] }

    factory :webhook_scrobbler, class: Scrobblers::WebhookScrobbler
    factory :withings_scrobbler, class: Scrobblers::WithingsScrobbler do
      service { create :service, :withings2 }
      options { { categories: Scrobblers::WithingsScrobbler::CATEGORIES } }
    end
  end
end
