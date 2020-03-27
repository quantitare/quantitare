# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LocationImport do
  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:adapter) }

  it { should belong_to(:user) }
  it { should have_many(:location_scrobbles) }

  it { should have_db_index :user_id }

  subject { build :location_import }

  it_behaves_like HasGuid

  describe '.adapters' do
    subject { LocationImport }

    let(:action) { subject.adapters }

    it 'is enumerable' do
      expect(action).to respond_to(:each)
    end
  end

  describe '.add_adapter' do
    let(:adapter) { Class.new }
    subject { LocationImport }

    let(:action) { subject.add_adapter(adapter) }

    it 'adds to adapters' do
      action

      expect(subject.adapters).to include(adapter)
    end
  end

  describe '#source_identifier' do
    it 'is the adapter name' do
      expect(subject.source_identifier).to eq(subject.adapter)
    end
  end

  describe '#source_match_condition' do
    it 'returns the right condition' do
      expect(subject.source_match_condition).to eq({ location_imports: { adapter: subject.adapter } })
    end
  end

  describe '#interval' do
    let(:start_time_1) { 24.hours.ago }
    let(:end_time_1) { 23.hours.ago }
    let(:scrobble_1) { create :place_scrobble, start_time: start_time_1, end_time: end_time_1 }

    let(:start_time_2) { 22.hours.ago }
    let(:end_time_2) { 21.hours.ago }
    let(:scrobble_2) { create :place_scrobble, start_time: start_time_2, end_time: end_time_2 }

    let(:location_scrobbles) { [scrobble_1] }

    subject { create :location_import, location_scrobbles: location_scrobbles }

    it 'reflects the values of a single scrobble' do
      expect(subject.interval).to match_array([start_time_1, end_time_1])
    end

    context 'with multiple scrobbles in order' do
      let(:location_scrobbles) { [scrobble_1, scrobble_2] }

      it 'expands itself to match the min start time and max end time' do
        expect(subject.interval).to match_array([start_time_1, end_time_2])
      end
    end

    context 'with multiple scrobbles out of order' do
      let(:location_scrobbles) { [scrobble_2, scrobble_1] }

      it 'correctly computes the interval' do
        expect(subject.interval).to match_array([start_time_1, end_time_2])
      end
    end

    context 'with overlapping times' do
      let(:start_time_3) { 23.5.hours.ago }
      let(:end_time_3) { 20.hours.ago }
      let(:scrobble_3) { create :place_scrobble, start_time: start_time_3, end_time: end_time_3 }

      let(:location_scrobbles) { [scrobble_1, scrobble_2, scrobble_3] }

      it 'computes the correct values' do
        expect(subject.interval).to match_array([start_time_1, end_time_3])
      end
    end
  end

  describe '#prepared_adapter' do
    it 'retuns nil when it is not ready' do
      expect(subject.prepared_adapter).to be_nil
    end

    context 'when it is ready' do
      subject { create :location_import, :with_file }

      it 'returns something that responds to #location_scrobbles' do
        expect(subject.prepared_adapter).to respond_to(:location_scrobbles)
      end
    end
  end

  describe '#preparable_adapter?' do
    it 'returns false with no import file' do
      expect(subject.preparable_adapter?).to be(false)
    end

    context 'when file is present' do
      subject { create :location_import, :with_file }

      it 'returns true' do
        expect(subject.preparable_adapter?).to be(true)
      end
    end
  end

  describe '#adapter_klass' do
    let(:import_with_nil_adapter) { build :location_import, adapter: nil }
    subject { create :location_import, adapter: 'GoogleMapsKMLAdapter' }

    it 'returns the correct class when present' do
      expect(subject.adapter_klass).to eq(GoogleMapsKMLAdapter)
    end

    it 'returns nil with no adapter' do
      expect(import_with_nil_adapter.adapter_klass).to be_nil
    end
  end
end
