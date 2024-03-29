require 'rails_helper'

# +subject+ must be a new instance of the record.
shared_examples_for LocationScrobble do
  it_behaves_like HasGuid
  it_behaves_like Periodable
  it_behaves_like Categorizable

  it { should validate_presence_of :start_time }
  it { should validate_presence_of :end_time }

  describe '#longitude' do
    it 'returns a number when trackpoints are present' do
      subject.trackpoints = [{ latitude: 1, longitude: 1 }]
      subject.validate

      expect(subject.longitude).to be_a(Numeric)
    end

    it 'returns nil when trackpoints are not present' do
      subject.trackpoints = []
      subject.validate

      expect(subject.longitude).to be_nil
    end
  end

  describe '#latitude' do
    it 'returns a number when trackpoints are present' do
      subject.trackpoints = [{ latitude: 1, longitude: 1 }]
      subject.validate

      expect(subject.latitude).to be_a(Numeric)
    end

    it 'returns nil when trackpoints are not present' do
      subject.trackpoints = []
      subject.validate

      expect(subject.latitude).to be_nil
    end
  end

  describe '#duration' do
    it 'returns a durationable object' do
      expect(subject.duration).to respond_to(:seconds)
    end
  end
end
