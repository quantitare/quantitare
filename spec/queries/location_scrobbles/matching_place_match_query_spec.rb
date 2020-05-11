# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationScrobbles::MatchingPlaceMatchQuery, :vcr do
  describe '#call' do
    let(:name) { Faker::Lorem.words(number: 2).join(' ') }
    let(:source_field_name) { name }

    let(:place_match) { build :place_match, source_field_name: source_field_name, source_field_radius: nil }

    let!(:matching_location_scrobble_1) do
      create :place_scrobble, name: name, source: place_match.source
    end
    let!(:non_matching_location_scrobble_1) do
      create :place_scrobble, name: 'This should not match', source: place_match.source
    end


    subject { LocationScrobbles::MatchingPlaceMatchQuery }

    it 'matches only the one that matches' do
      expect(subject.(place_match: place_match)).to include(matching_location_scrobble_1)
    end

    it 'does not match the one that does not match' do
      expect(subject.(place_match: place_match)).to_not include(non_matching_location_scrobble_1)
    end

    context 'with more than one match' do
      let!(:matching_location_scrobble_2) { create :place_scrobble, name: name }

      it 'matches with all matches' do
        expect(
          subject.(place_match: place_match)).to include(matching_location_scrobble_1, matching_location_scrobble_2
        )
      end
    end

    context 'with more complex matching conditions' do
      let(:longitude) { 1 }
      let(:latitude) { 1 }

      let(:place_match) do
        create :place_match,
          source_field_name: source_field_name,
          source_field_longitude: longitude,
          source_field_latitude: latitude,
          source_field_radius: 1
      end

      let!(:matching_location_scrobble_1) do
        create :place_scrobble,
          name: name,
          source: place_match.source,
          trackpoints: [{ longitude: longitude, latitude: latitude }]
      end
      let!(:non_matching_location_scrobble_1) do
        create :place_scrobble,
          name: name,
          source: place_match.source,
          trackpoints: [{ longitude: longitude, latitude: latitude + 100 }]
      end

      it 'matches only the one that matches' do
        expect(subject.(place_match: place_match)).to include(matching_location_scrobble_1)
      end

      it 'does not match the one that does not match' do
        expect(subject.(place_match: place_match)).to_not include(non_matching_location_scrobble_1)
      end
    end
  end
end
