# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MatchPlaceToLocationScrobble, :vcr do
  subject { MatchPlaceToLocationScrobble }
  let(:place) { create :place }
  let(:place_match) { create :place_match, place: place }
  let(:location_scrobble) { create :place_scrobble }

  let(:query) { double 'query', call: place_match }

  describe '#call' do
    let(:action) { subject.(location_scrobble, query: query) }

    it "sets the location_scrobble's place" do
      action

      expect(location_scrobble.place).to eq(place)
    end

    it 'is successful' do
      expect(action).to be_successful
    end

    context 'when the query does not return a match' do
      let(:query) { double 'query', call: nil }

      it "does not change the location_scrobble's place" do
        expect { action }.to_not change(location_scrobble, :place)
      end

      it 'is successful' do
        expect(action).to be_successful
      end
    end

    context 'when there are some errors' do
      let(:location_scrobble) { create :place_scrobble, singular: true }

      it "does not change the location_scrobble's place" do
        expect { action }.to_not change { location_scrobble.reload.place }
      end

      it 'is not successful' do
        expect(action).to_not be_successful
      end
    end
  end
end
