# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class ResponseVerifier
    NON_FATAL_STATUSES = [511, 601].to_set.freeze

    attr_reader :response

    def initialize(response)
      @response = response
    end

    def process!
      handle_unsuccessful_response unless response.success?

      return if status.zero?

      handle_nonzero_response_status
    end

    private

    def status
      @status ||= response.body['status']
    end

    def message
      @message ||= response.body['error']
    end

    def handle_unsuccessful_response
      case response.status
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

    def handle_nonzero_response_status
      raise Errors::ServiceAPIError, message if status.in?(NON_FATAL_STATUSES)

      raise Errors::ServiceConfigError, message
    end
  end
end
