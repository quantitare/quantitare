# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :location_import do
    user
    adapter { 'GoogleMapsKMLAdapter' }

    trait :with_scrobbles do
      transient do
        scrobble_count { 1 }
      end

      after(:create) { |import, evaluator| create_list(:place_scrobble, evaluator.scrobble_count, source: import) }
    end

    trait :with_file do
      transient do
        filename { 'google_maps_kml_import.kml' }
        file_path { Rails.root.join('spec', 'fixtures', 'files', filename) }
      end

      import_file { fixture_file_upload(file_path) }
    end
  end
end
