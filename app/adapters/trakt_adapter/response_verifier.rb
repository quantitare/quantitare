# frozen_string_literal: true

class TraktAdapter
  ##
  # @private
  #
  class ResponseVerifier
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def process!
      handle_unsuccessful_response unless response.success?
    end

    private

    def handle_unsuccessful_response
      raise Errors::ServiceAPIError, 'Too many requests' if response.status.to_i == 429

      case response.status.to_i
      when 400..499
        raise Errors::ServiceConfigError.new <<~TEXT.squish, nature: Service::IN_REQUEST_FORMAT
          An attempt was made to fetch data from this service, but it received a status of #{response.status}. This
          could be an issue with how the service is configured, or a bug in the adapter.
        TEXT
      when 500..599
        raise Errors::ServiceAPIError
      else
        raise Errors::ServiceAPIError
      end
    end
  end
end
