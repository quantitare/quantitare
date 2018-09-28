# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceMatch, :vcr do
  subject { build :place_match }

  it { should belong_to(:user) }
  it { should belong_to(:source) }
  it { should belong_to(:place) }

  describe 'validations' do
    subject { create :place_match }

    it { should validate_presence_of(:source_fields) }
    it do
      should(
        validate_uniqueness_of(:source_fields)
        .scoped_to(:user_id, :source_identifier)
        .with_message('cannot have two place assignments per source')
      )
    end
  end

  describe '#source_identifier' do
    it 'is set automatically' do
      subject.validate

      expect(subject.source_identifier).to be_present
    end

    it "equals the source's source_identifier" do
      subject.validate

      expect(subject.source_identifier).to eq(subject.source.source_identifier)
    end
  end

  describe '#matching_location_scrobbles' do
    let(:name) { Faker::Lorem.words(2).join(' ') }
    let(:source_fields) { { name: name } }

    let!(:matching_location_scrobble_1) { create :place_scrobble, name: name }
    let!(:non_matching_location_scrobble_1) { create :place_scrobble, name: 'This should not match' }

    subject { build :place_match, source_fields: source_fields }

    it 'matches only the one that matches' do
      expect(subject.matching_location_scrobbles).to include(matching_location_scrobble_1)
    end

    it 'does not match the one that does not match' do
      expect(subject.matching_location_scrobbles).to_not include(non_matching_location_scrobble_1)
    end

    context 'with more than one match' do
      let!(:matching_location_scrobble_2) { create :place_scrobble, name: name }

      it 'matches with all matches' do
        expect(
          subject.matching_location_scrobbles).to include(matching_location_scrobble_1, matching_location_scrobble_2
        )
      end
    end

    context 'with more complex matching conditions' do
      let(:longitude) { 1 }
      let(:latitude) { 2 }
      let(:source_fields) { { name: name, longitude: longitude, latitude: latitude } }

      let!(:matching_location_scrobble_1) do
        create :place_scrobble, name: name, longitude: longitude, latitude: latitude
      end
      let!(:non_matching_location_scrobble_1) do
        create :place_scrobble, name: name, longitude: longitude, latitude: latitude + 1
      end

      it 'matches only the one that matches' do
        expect(subject.matching_location_scrobbles).to include(matching_location_scrobble_1)
      end

      it 'does not match the one that does not match' do
        expect(subject.matching_location_scrobbles).to_not include(non_matching_location_scrobble_1)
      end
    end
  end
end
