# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceScrobble do
  subject { build :place_scrobble }

  it_behaves_like LocationScrobble

  describe '.category_klass' do
    it 'contains the right categories' do
      expect(PlaceScrobble.category_klass).to eq(PlaceCategory)
    end
  end

  describe '#place?' do
    it 'returns true' do
      expect(subject.place?).to be(true)
    end
  end

  describe '#transit?' do
    it 'returns false' do
      expect(subject.transit?).to be(false)
    end
  end

  describe '#friendly_type' do
    it 'returns a string' do
      expect(subject.friendly_type).to be_a(String)
    end
  end

  describe '#category_klass' do
    it 'returns the right class' do
      expect(subject.category_klass).to eq(PlaceCategory)
    end
  end

  describe '#category_info' do
    it 'returns something that responds to #name' do
      expect(subject.category_info).to respond_to(:name)
    end

    it 'returns something that responds to #icon' do
      expect(subject.category_info).to respond_to(:icon)
    end
  end
end
