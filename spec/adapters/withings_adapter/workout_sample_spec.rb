# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::WorkoutSample do
  let(:data) { JSON.parse(file_fixture('withings_workout_response_body.json').read)['body']['series'] }
  subject { WithingsAdapter::WorkoutSample.new('workout', data[0]) }

  describe '#to_scrobble' do
    let(:action) { subject.to_scrobble }

    it 'sets the category' do
      expect(action.category).to eq('workout')
    end

    it 'creates valid data JSON' do
      result = action
      result.validate

      expect(result.errors[:data]).to be_blank
    end

    it 'sets the proper start_time' do
      expect(action.start_time).to eq(Time.zone.at(1561848840))
    end

    it 'sets the proper end_time' do
      expect(action.end_time).to eq(Time.zone.at(1561849200))
    end

    context 'when the category is not a valid category' do
      subject { WithingsAdapter::WorkoutSample.new('workout', data[4]) }

      it 'returns a blank' do
        expect(action).to be_blank
      end
    end
  end
end
