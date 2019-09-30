# frozen_string_literal: true

FactoryBot.define do
  factory :scrobbler, class: Scrobblers::DummyScrobbler do
    user

    name { Faker::Lorem.words(number: 1)[0] }

    factory :rescuetime_scrobbler, class: Scrobblers::RescuetimeScrobbler do
      service { create :service, :rescuetime }
      options { { time_zone: 'Pacific Time (US & Canada)' } }
    end

    factory :todoist_scrobbler, class: Scrobblers::TodoistScrobbler do
      service { create :service, :todoist }
    end

    factory :trakt_scrobbler, class: Scrobblers::TraktScrobbler do
      service { create :service, :trakt }
      options { { categories: Scrobblers::TraktScrobbler::CATEGORIES } }
    end

    factory :twitter_scrobbler, class: Scrobblers::TwitterScrobbler do
      service { create :service, :twitter }
    end

    factory :webhook_scrobbler, class: Scrobblers::WebhookScrobbler

    factory :withings_scrobbler, class: Scrobblers::WithingsScrobbler do
      service { create :service, :withings2 }
      options { { categories: Scrobblers::WithingsScrobbler::CATEGORIES } }
    end
  end
end
