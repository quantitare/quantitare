# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::SleepSample do
  let(:data) { JSON.parse(file_fixture('withings_sleep_response_body.json').read)['body']['series'] }

  describe '#to_scrobble' do
    let(:action) { subject.to_scrobble }

    context 'when the desired output is an aggregate' do
      subject { WithingsAdapter::SleepSample.new('aggregate_category', data, { aggregate: true }) }

      it 'aggregates the samples based on timestamps' do
        expect(action.length).to be < data.length
      end

      it 'sets the proper category' do
        expect(action.first.category).to eq('aggregate_category')
      end

      it 'does not have overlapping timestamps' do
        results = action
        is_cool = results.none? do |result|
          results.none? do |other_result|
            (result.start_time..result.end_time).overlaps?(other_result.start_time..other_result.end_time)
          end
        end

        expect(is_cool).to be(true)
      end

      it 'retuns valid data' do
        result = action.first
        result.validate

        expect(result.errors[:data]).to be_empty
      end
    end

    context 'when the desired output is from individual datapoints' do
      subject do
        WithingsAdapter::SleepSample.new(
          'datapoint_category', data[2], { individual_datapoints: true, datapoint_name: 'hr', key: 'the_key' }
        )
      end

      it 'returns an array' do
        expect(action).to be_an(Array)
      end

      it 'collects data from the correct source' do
        expect(action.first.data['the_key']).to eq(63)
      end

      it 'sets the proper category' do
        expect(action.first.category).to eq('datapoint_category')
      end

      it 'sets the proper timestamp' do
        expect(action.first.timestamp).to eq(Time.zone.at(1561884360))
      end

      it 'retuns valid data' do
        result = action.first
        result.validate

        expect(result.errors[:data]).to be_empty
      end
    end

    context 'when the desired output is from the root sample' do
      subject { WithingsAdapter::SleepSample.new('root_category', data[2], {}) }

      it 'sets the proper category' do
        expect(action.category).to eq('root_category')
      end

      it 'sets the start_time from the sample' do
        expect(action.start_time).to eq(Time.zone.at(1561884360))
      end

      it 'sets the end_time from the sample' do
        expect(action.end_time).to eq(Time.zone.at(1561884960))
      end

      it 'sets the depth value in the data hash' do
        expect(action.data['depth']).to eq(Categories::Sleep::D_LIGHT)
      end

      it 'retuns valid data' do
        result = action
        result.validate

        expect(result.errors[:data]).to be_empty
      end
    end
  end
end
