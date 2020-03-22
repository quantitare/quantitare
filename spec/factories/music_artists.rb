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
    expires_at { Faker::Time.forward(days: 14, period: :all) }

    trait :with_service do
      service
    end

    trait :with_tags do
      tag_list { Faker::Lorem.words(number: 5).join(', ') }
    end

    trait :with_bio do
      after(:build) do |artist|
        full_bio = Faker::Lorem.paragraphs(number: 3)

        artist.data[:bio] = {
          summary: full_bio[0],
          content: full_bio.join("\n\n")
        }
      end
    end

    trait :with_image do
      after(:build) do |artist|
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
