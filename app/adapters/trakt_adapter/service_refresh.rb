# frozen_string_literal: true

class TraktAdapter
  ##
  # @private
  #
  class ServiceRefresh
    attr_reader :service

    def initialize(service)
      @service = service.reload.decorate
    end

    def process!
      response, refresh_params = fetch_refresh_data

      if response.success?
        process_refresh!(refresh_params)
      else
        raise Errors::ServiceConfigError.new(<<~TEXT.squish, nature: Service::IN_REFRESH_TOKEN)
          We couldn't refresh the access token for the service #{service.name}. You may need to re-authenticate with
          the service.
        TEXT
      end
    end

    private

    def fetch_refresh_data
      response = refresh_token_response
      params = JSON.parse(response.body)

      [response, params]
    end

    def refresh_token_response
      Faraday.new(url: API_URL).post('/oauth/token') do |request|
        request.headers = { 'Content-Type' => 'application/json' }

        request.body = {
          grant_type: 'refresh_token',
          client_id: service.provider_key,
          client_secret: service.provider_secret,
          redirect_uri: '',
          refresh_token: service.refresh_token
        }.to_json
      end
    end

    # Expected params:
    #
    #   {
    #     "access_token" => "abc123",
    #     "expires_in" => "10800",
    #     "token_type" => "Bearer",
    #     "scope" => "public",
    #     "refresh_token" => "def456",
    #     "created_at": 1487889741
    #   }
    #
    def process_refresh!(refresh_params)
      service.update!(
        token: refresh_params['access_token'],
        refresh_token: refresh_params['refresh_token'],
        expires_at: Time.zone.at(refresh_params['created_at']) + refresh_params['expires_in'].to_i.seconds
      )
    end
  end
end
