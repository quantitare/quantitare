# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WithingsAdapter, :vcr do
  let(:service) { create :service, :withings2 }
  subject { WithingsAdapter.new(service) }

  it 'has valid requests for all categories' do
    categories = Scrobblers::WithingsScrobbler::CATEGORIES
    requests = subject.requests_for_categories(
      categories, Time.zone.parse('2019-06-29 19:00:22 UTC'), Time.zone.parse('2019-06-30 19:00:22 UTC')
    )

    responses = requests.map { |request| subject.fetch(request) }

    expect(responses.all? { |res| res.body['status'].zero? }).to be(true)
  end

  describe '#fetch_scrobbles' do
    it 'returns a list of scrobbles' do
      result = subject.fetch_scrobbles(
        Time.zone.parse('2019-06-29 19:00:22 UTC'),
        Time.zone.parse('2019-06-30 19:00:22 UTC'),
        categories: Scrobblers::WithingsScrobbler::CATEGORIES
      )

      expect(result.all? { |scr| scr.is_a?(::Scrobble) }).to be(true)
    end
  end

  describe '#responses_for_request' do
    let(:request) do
      WithingsAdapter::Request.new('workout', 'measure',
        action: 'getworkouts',
        data_fields: 'calories,distance,effduration,elevation,hr_average,hr_max,hr_min,hr_zone_0,hr_zone_1,hr_zone_2,hr_zone_3,intensity,pool_laps,pool_length,steps,strokes'
      ).tap do |req|
        req.set_timestamps(Time.zone.parse('2019-06-26 04:43:05 UTC'), Time.zone.parse('2019-07-03 04:43:05 UTC'))
      end
    end

    it 'returns a list of responses' do
      result = subject.responses_for_request(request)
      expect(result.all? { |response| response.respond_to?(:body) }).to be(true)
    end

    it 'returns successful responses when everything goes well' do
      result = subject.responses_for_request(request)
      expect(result.all? { |response| response.success? }).to be(true)
    end
  end

  describe '#scrobbles_for_response' do
    let(:request) do
      double 'request',
        categories: ['heart_rate', 'sleep'],
        endpoint_config: { extract_data_from: :sleep },
        endpoint: ['sleep', 'get']
    end

    let(:response) do
      double 'response', body: JSON.parse(file_fixture('withings_sleep_response_body.json').read), success?: true
    end

    it 'returns a list of Scrobble objects' do
      expect(subject.scrobbles_for_response(response, request).all? { |item| item.is_a?(::Scrobble) }).to be(true)
    end
  end

  describe '#fetch' do
    let(:request) do
      double 'request', path: 'sleep', params: {
        action: 'get',
        startdate: Time.zone.parse('2019-06-27 20:40:45 UTC').to_i,
        enddate: Time.zone.parse('2019-06-28 20:40:45 UTC').to_i,
        data_fields: 'hr,rr'
      }
    end
    let(:action) { subject.fetch(request) }

    it 'is successful' do
      expect(action).to be_success
    end

    it 'has a status of 0 when everything is fine' do
      expect(action.body['status']).to be_zero
    end

    it 'has content when everything is fine' do
      expect(action.body['body']).to be_present
    end

    context 'with invalid params' do
      let(:request) do
        double 'request', path: 'sleep', params: {
          action: 'get',
          enddate: Time.zone.parse('2019-06-28 20:40:45 UTC').to_i,
          data_fields: 'hr,rr'
        }
      end

      it 'has a nonzero status' do
        expect(action.body['status']).to_not be_zero
      end
    end

    context 'with an invalid token' do
      let(:service) { create :service, :withings2, token: 'some_nonsense' }

      it 'has a nonzero status' do
        expect(action.body['status']).to_not be_zero
      end

      it 'is a successful response' do
        expect(action).to be_success
      end
    end

    context 'with an expired token' do
      let(:service) { create :service, :withings2, :expired, token: 'some_expired_token' }

      it 'refreshes the service token' do
        expect { action }.to change(service, :token)
      end

      it 'raises an error if there is a problem with the refresh' do
        service.update refresh_token: 'some_nonsense'

        expect { action }.to raise_error(Errors::ServiceConfigError)
      end

      it 'reports an issue to the service if there is a problem with the refresh' do
        service.update refresh_token: 'some_nonsense'

        begin
          action
        rescue Errors::ServiceConfigError
        end

        expect(service).to be_issues
      end
    end
  end
end
