# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindPlaceMatchForLocationScrobble, :vcr do
  describe '#call' do
    subject { FindPlaceMatchForLocationScrobble }

    let(:name) { Faker::Lorem.words(number: 2).join(' ') }
    let(:other_name) { Faker::Lorem.words(number: 2).join(' ') + ' & does not match' }
    let(:longitude) { '1.0'.to_d }
    let(:latitude) { '2.0'.to_d }

    let(:location_scrobble) { build :place_scrobble, name: name, longitude: longitude, latitude: latitude }

    let!(:full_match_place_match) do
      create :place_match,
        source_field_name: name,
        source_field_radius: 1,
        source_field_longitude: longitude,
        source_field_latitude: latitude,
        user: location_scrobble.user
    end

    let!(:less_specific_matching_place_match) do
      create :place_match,
        source_field_radius: 1,
        source_field_latitude: latitude,
        source_field_longitude: longitude,
        user: location_scrobble.user
    end

    let!(:different_name_matching_place_match) do
      create :place_match,
        source_field_name: other_name,
        source_field_radius: 1,
        source_field_latitude: latitude,
        source_field_longitude: longitude,
        user: location_scrobble.user
    end

    let!(:non_matching_place_match) do
      create :place_match,
        source_field_radius: 1,
        source_field_latitude: latitude - 150,
        source_field_longitude: longitude + 150,
        user: location_scrobble.user
    end

    it 'returns the most specific match' do
      expect(subject.(location_scrobble)).to eq(full_match_place_match)
    end
  end
end
