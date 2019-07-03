# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter::Scrobble do
  describe '.from_api' do
    let(:request) do
      double 'request',
        categories: ['heart_rate', 'sleep'],
        endpoint_config: { extract_data_from: :sleep },
        endpoint: ['sleep', 'get']
    end

    let(:response) { double 'response', body: file_fixture('withings_sleep_response_body.json').read }

    it 'returns a list' do
      expect(WithingsAdapter::Scrobble.from_api(response, request)).to be_a(Array)
    end

    it 'returns a list of scrobbles' do
      expect(WithingsAdapter::Scrobble.from_api(response, request).all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end
  end

  describe '#samples' do
    context 'with a "series" response' do
      let(:response) { double 'response', body: file_fixture('withings_series_response_body.json').read }
      let(:request) do
        double 'request', endpoint: ['measure', 'getintradayactivity'], endpoint_config: { extract_data_from: :series }
        end
      subject { WithingsAdapter::Scrobble.new(response, request, 'steps') }

      it 'returns a collection' do
        expect(subject.samples).to be_an(Array)
      end
    end

    context 'with a "measuregrps" response' do
      let(:response) { double 'response', body: file_fixture('withings_measuregrps_response_body.json').read }
      let(:request) do
        double 'request', endpoint: ['/measure', 'getmeas'], endpoint_config: { extract_data_from: :measuregrps }
      end
      subject { WithingsAdapter::Scrobble.new(response, request, 'weight') }

      it 'returns a collection' do
        expect(subject.samples).to be_an(Array)
      end
    end

    context 'with a "sleep" response' do
      let(:response) { double 'response', body: file_fixture('withings_sleep_response_body.json').read }
      let(:request) do
        double 'request', endpoint: ['sleep', 'get'], endpoint_config: { extract_data_from: :sleep }
      end
      subject { WithingsAdapter::Scrobble.new(response, request, 'sleep') }

      it 'returns a collection' do
        expect(subject.samples).to be_an(Array)
      end
    end

    context 'with a "workout" response' do
      let(:response) { double 'response', body: file_fixture('withings_workout_response_body.json').read }
      let(:request) do
        double 'request', endpoint: ['measure', 'getworkouts'], endpoint_config: { extract_data_from: :workout }
      end
      subject { WithingsAdapter::Scrobble.new(response, request, 'workout') }

      it 'returns an array' do
        expect(subject.samples).to be_an(Array)
      end
    end
  end
end
