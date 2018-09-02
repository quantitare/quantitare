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
    expires_at { Faker::Time.forward(14, :all) }

    trait :with_service do
      service
    end

    trait :expired do
      expires_at { Faker::Time.between(30.days.ago, 1.minute.ago, :all) }
    end
  end
end
