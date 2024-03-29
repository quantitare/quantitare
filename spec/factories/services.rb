# frozen_string_literal: true

FactoryBot.define do
  factory :service do
    user
    provider { Faker::Lorem.words(number: 1) }
    name { Faker::Lorem.words(number: 1) }
    token { SecureRandom.hex }

    trait :with_secret do
      secret { SecureRandom.hex }
    end

    trait :expired do
      expires_at { 24.hours.ago }
    end

    trait :flickr do
      provider { :flickr }
      uid { '67275002@N00' }
      token { ENV['FLICKR_TEST_USER_TOKEN'] }
      secret { ENV['FLICKR_TEST_USER_SECRET'] }
    end

    trait :github do
      provider { :github }
      uid { ENV['GITHUB_TEST_USER_UID'] }
      token { ENV['GITHUB_TEST_USER_TOKEN'] }
      options { { "name" => "aastronautss-dev" } }
    end

    trait :rescuetime do
      provider { :rescuetime }
      token { ENV['RESCUETIME_TEST_USER_TOKEN'] }
    end

    trait :todoist do
      provider { :todoist }
      token { ENV['TODOIST_TEST_USER_TOKEN'] }
    end

    trait :trakt do
      provider { :trakt }
      token { ENV['TRAKT_TEST_USER_TOKEN'] }
      refresh_token { ENV['TRAKT_TEST_USER_REFRESH_TOKEN'] }
      options { { name: 'Trakt.tv' } }
    end

    trait :twitter do
      provider { :twitter }
      token { ENV['TWITTER_TEST_USER_TOKEN'] }
      secret { ENV['TWITTER_TEST_USER_SECRET'] }
      options { { name: 'tyler_throwaway' } }
    end

    trait :withings2 do
      provider { :withings2 }
      token { ENV['WITHINGS_TEST_USER_TOKEN'] }
      refresh_token { ENV['WITHINGS_TEST_USER_REFRESH_TOKEN'] }
      options { { name: 'Withings' } }
    end
  end
end
