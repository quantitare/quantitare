require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for LocationScrobble do
  it_behaves_like HasGuid
  it_behaves_like Periodable

  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  describe '#average_longitude' do
    it 'returns a number when trackpoints are present' do
      subject.trackpoints = [{ latitude: 1, longitude: 1 }]

      expect(subject.average_longitude).to be_a(Numeric)
    end

    it 'returns nil when trackpoints are not present' do
      subject.trackpoints = []

      expect(subject.average_longitude).to be_nil
    end
  end

  describe '#average_latitude' do
    it 'returns a number when trackpoints are present' do
      subject.trackpoints = [{ latitude: 1, longitude: 1 }]

      expect(subject.average_latitude).to be_a(Numeric)
    end

    it 'returns nil when trackpoints are not present' do
      subject.trackpoints = []

      expect(subject.average_latitude).to be_nil
    end
  end
end
