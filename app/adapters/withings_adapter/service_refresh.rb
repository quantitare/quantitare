# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class ServiceRefresh
    include ServiceRefreshable

    attr_reader :service

    def initialize(service)
      @service = service
    end

    def fetch_refresh_data
      response = refresh_token_response
      params = JSON.parse(response.body).merge('date' => Time.zone.parse(response.env.response_headers['date']))

      [response, params]
    end

    def refresh_token_response
      Faraday.new(url: ACCOUNT_URL).post do |request|
        request.body = {
          grant_type: 'refresh_token',
          client_id: service.provider_key,
          client_secret: service.provider_secret,
          refresh_token: service.refresh_token
        }.to_param
      end
    end

    # Expected params:
    #
    #   {
    #     "access_token" => "abc123",
    #     "expires_in" => "10800",
    #     "token_type" => "Bearer",
    #     "scope" => "user.activity,user.metrics,user.info",
    #     "refresh_token" => "def456",
    #     "userid" => 1234567,
    #     "date" => 2019-06-29 18:54:01 +0000
    #   }
    #
    def process_refresh!(refresh_params)
      service.update!(
        token: refresh_params['access_token'],
        refresh_token: refresh_params['refresh_token'],
        expires_at: refresh_params['date'] + refresh_params['expires_in'].to_i.seconds
      )
    end
  end
end
