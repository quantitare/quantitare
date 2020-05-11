# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceMatch, :vcr do
  subject { build :place_match }

  it { should belong_to(:user) }
  it { should belong_to(:source) }
  it { should belong_to(:place) }

  describe 'validations' do
    subject { create :place_match }

    it 'is invalid if coordinates are not provided' do
      expect(
        build :place_match, source_field_radius: 1, source_field_longitude: nil, source_field_latitude: nil
      ).to be_invalid
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
    let(:query) { double 'query' }

    it 'delegates to the query' do
      expect(query).to receive(:call).with(hash_including(place_match: subject))

      subject.matching_location_scrobbles(query)
    end
  end
end
