# frozen_string_literal: true

FactoryBot.define do
  factory :music_track, class: Aux::MusicTrack do
    transient do
      mbid { nil }
      title { Faker::Dessert.flavor }
      artist_name { Faker::Music.band }
    end

    data do
      {
        mbid: mbid,

        title: title,
        duration: rand(120000..420000),

        artist_name: artist_name
      }.compact
    end
    expires_at { Faker::Time.forward(days: 14, period: :all) }

    trait :with_service do
      service
    end

    trait :expired do
      expires_at { Faker::Time.between(from: 30.days.ago, to: 1.week.ago) }
    end
  end
end
