# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PointScrobble do
  subject { build :point_scrobble }

  it_behaves_like Scrobble

  describe 'validations' do
    it 'is not valid if start_time and end_time are different' do
      subject.start_time = Time.now
      subject.end_time = 10.years.ago

      expect(subject).to_not be_valid
    end
  end

  describe '#timestamp=' do
    subject { build :point_scrobble, timestamp: 1.month.ago }

    it 'should set start_time and end_time automatically' do
      expect(subject.start_time).to be_present
      expect(subject.end_time).to be_present
    end

    it 'should change start_time and end_time when it changes' do
      subject.timestamp = 1.year.ago

      expect(subject.start_time).to eq(subject.timestamp)
      expect(subject.end_time).to eq(subject.end_time)
    end

    it 'should keep it valid' do
      expect(subject).to be_valid
    end

    it 'should persist start_time and end_time after saving' do
      subject.save!
      subject.reload

      expect(subject.start_time).to be_present
      expect(subject.end_time).to be_present
    end
  end

  describe '#timestamp' do
    it 'retrieves correctly after saving' do
      time = 1.day.ago
      subject.timestamp = time

      subject.save!
      subject.reload

      expect(subject.timestamp).to eq(time)
    end
  end
end
