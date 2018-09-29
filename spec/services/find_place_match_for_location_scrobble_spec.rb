# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FindPlaceMatchForLocationScrobble, :vcr do
  describe '#call' do
    subject { FindPlaceMatchForLocationScrobble }

    let(:name) { Faker::Lorem.words(2).join(' ') }
    let(:other_name) { Faker::Lorem.words(2).join(' ') + ' & does not match' }
    let(:longitude) { '1.0' }
    let(:latitude) { '2.0' }

    let(:location_scrobble) { build :place_scrobble, name: name, longitude: longitude, latitude: latitude }

    let!(:full_match_place_match) do
      create :place_match, source_fields: { name: name, longitude: longitude, latitude: latitude }
    end

    let!(:less_specific_matching_place_match) do
      create :place_match, source_fields: { longitude: longitude, latitude: latitude }
    end

    let!(:different_name_matching_place_match) do
      create :place_match, source_fields: { name: other_name, longitude: longitude, latitude: latitude }
    end

    let!(:non_matching_place_match) do
      create :place_match, source_fields: { longitude: 'hello', latitude: 'world' }
    end

    it 'returns the most specific match' do
      expect(subject.(location_scrobble)).to eq(full_match_place_match)
    end
  end
end
