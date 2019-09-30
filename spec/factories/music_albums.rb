# frozen_string_literal: true

FactoryBot.define do
  factory :music_album, class: Aux::MusicAlbum do
    transient do
      mbid { nil }
      title { Faker::Lorem.words(number: 4).join(' ') }
      release_date { nil }

      artist_name { Faker::Music.band }
      artist_mbid { nil }

      tracks do
        [{
          rank: 1,
          title: Faker::Lorem.words(number: 4).join(' '),
          artist_name: artist_name
        }]
      end
    end

    data do
      {
        mbid: mbid,
        title: title,

        artist_name: artist_name,
        artist_mbid: artist_mbid,

        tracks: tracks
      }.compact
    end
    expires_at { Faker::Time.forward(days: 14, period: :all) }

    trait :with_service do
      service
    end

    trait :with_tags do
      tag_list { Faker::Lorem.words(number: 5).join(', ') }
    end

    trait :with_info do
      after(:build) do |album|
        full_info = Faker::Lorem.paragraphs(number: 3)

        album.data[:info] = {
          summary: full_info[0],
          content: full_info.join("\n\n")
        }
      end
    end

    trait :with_image do
      after(:build) do |album|
        artist.data[:image] = {
          small: Faker::Placeholdit.image(size: '50x50'),
          medium: Faker::Placeholdit.image(size: '100x100'),
          large: Faker::Placeholdit.image(size: '400x400'),
          original: Faker::Placeholdit.image(size: '800x800')
        }
      end
    end

    trait :expired do
      expires_at { Faker::Time.between(from: 30.days.ago, to: 1.week.ago) }
    end
  end
end
