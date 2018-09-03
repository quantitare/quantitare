# frozen_string_literal: true

FactoryBot.define do
  factory :music_artist, class: Aux::MusicArtist do
    transient do
      mbid { nil }
      name { Faker::Music.band }
    end

    data do
      {
        mbid: mbid,
        name: name
      }.compact
    end
    expires_at { Faker::Time.forward(14, :all) }

    trait :with_service do
      service
    end

    trait :with_tags do
      tag_list { Faker::Lorem.words(5).join(', ') }
    end

    trait :with_bio do
      after(:build) do |artist|
        full_bio = Faker::Lorem.paragraphs(3)

        artist.data[:bio] = {
          summary: full_bio[0],
          content: full_bio.join("\n\n")
        }
      end
    end

    trait :with_image do
      after(:build) do |artist|
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
