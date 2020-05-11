# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceMatches::MatchingLocationScrobbleQuery, :vcr do
  subject { PlaceMatches::MatchingLocationScrobbleQuery }

  describe '#call' do
    let(:name) { Faker::Lorem.words(number: 2).join(' ') }
    let(:longitude) { '1.0'.to_d }
    let(:latitude) { '2.0'.to_d }

    let(:location_scrobble) { build :place_scrobble, longitude: longitude, latitude: latitude }
    let!(:matching_place_match) do
      create :place_match, source_field_longitude: longitude, source_field_latitude: latitude, source_field_radius: 0
    end
    let!(:non_matching_place_match) do
      create :place_match,
        source_field_longitude: longitude + 100,
        source_field_latitude: latitude,
        source_field_radius: 0
    end

    it 'returns a PlaceMatch whose source_fields match the related fields on the LocationScrobble' do
      expect(subject.(location_scrobble: location_scrobble)).to include(matching_place_match)
    end

    it 'excludes non-matching source_fields' do
      expect(subject.(location_scrobble: location_scrobble)).to_not include(non_matching_place_match)
    end

    context 'when matching against more than one attribute' do
      let(:location_scrobble) { build :place_scrobble, name: name, longitude: longitude, latitude: latitude }
      let!(:matching_place_match) do
        create :place_match,
          source_field_name: name,
          source_field_radius: 0,
          source_field_longitude: longitude,
          source_field_latitude: latitude
      end
      let!(:non_matching_place_match) do
        create :place_match,
          source_field_latitude: latitude + 150, source_field_longitude: longitude, source_field_radius: 0
      end

      it 'returns a PlaceMatch whose source_fields match the related fields on the LocationScrobble' do
        expect(subject.(location_scrobble: location_scrobble)).to include(matching_place_match)
      end

      it 'excludes non-matching source_fields' do
        expect(subject.(location_scrobble: location_scrobble)).to_not include(non_matching_place_match)
      end
    end

    context 'when more than one PlaceMatches match' do
      let(:location_scrobble) { build :place_scrobble, name: name, longitude: longitude, latitude: latitude }
      let!(:matching_place_match) do
        create :place_match,
          source_field_name: name,
          source_field_longitude: longitude,
          source_field_latitude: latitude,
          source_field_radius: 0
      end
      let!(:matching_place_match_2) do
        create :place_match,
          source_field_longitude: longitude,
          source_field_latitude: latitude,
          source_field_radius: 0
      end

      it 'returns all matching place matches' do
        expect(subject.(location_scrobble: location_scrobble)).to(
          include(matching_place_match, matching_place_match_2)
        )
      end
    end
  end
end
