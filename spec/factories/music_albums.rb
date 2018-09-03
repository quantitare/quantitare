# frozen_string_literal: true

FactoryBot.define do
  factory :music_album, class: Aux::MusicAlbum do
    transient do
      mbid { nil }
      title { Faker::Lorem.words(4).join(' ') }
      release_date { nil }

      artist_name { Faker::Music.band }
      artist_mbid { nil }

      tracks do
        [{
          rank: 1,
          title: Faker::Lorem.words(4).join(' '),
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
    expires_at { Faker::Time.forward(14, :all) }

    trait :with_service do
      service
    end

    trait :with_tags do
      tag_list { Faker::Lorem.words(5).join(', ') }
    end

    trait :with_info do
      after(:build) do |album|
        full_info = Faker::Lorem.paragraphs(3)

        album.data[:info] = {
          summary: full_info[0],
          content: full_info.join("\n\n")
        }
      end
    end

    trait :with_image do
      after(:build) do |album|
        artist.data[:image] = {
          small: Faker::Placeholdit.image('50x50'),
          medium: Faker::Placeholdit.image('100x100'),
          large: Faker::Placeholdit.image('400x400'),
          original: Faker::Placeholdit.image('800x800')
        }
      end
    end

    trait :expired do
      expires_at { Faker::Time.between(30.days.ago, 1.week.ago, :all) }
    end
  end
end
