# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def from_api(response, request)
        verify_response(response)

        request.categories.flat_map { |category| new(response, request, category).generate }
      end

      private

      def verify_response(response)
        WithingsAdapter::ResponseVerifier.new(response).process!
      end
    end

    delegate :endpoint_config, :endpoint, to: :request
    delegate :body, to: :response

    attr_reader :response, :request, :category

    def initialize(response, request, category)
      @response = response
      @request = request
      @category = category
    end

    def generate
      samples.compact.flat_map(&:to_scrobble).compact
    end

    def samples
      case endpoint_config[:extract_data_from]
      when :series
        samples_for_series
      when :measuregrps
        samples_for_measuregrps
      when :sleep
        samples_for_sleep
      when :workout
        samples_for_workout
      end
    end

    private

    def category_config
      WithingsAdapter::CategoryConfig.for_category_and_endpoint(category, endpoint)
    end

    def response_config
      category_config[:response_config] || {}
    end

    def samples_for_series
      body['body']['series'].map { |timestamp, data| SeriesSample.new(category, timestamp, data, response_config) }
    end

    def samples_for_measuregrps
      body['body']['measuregrps'].map { |data| MeasuregrpSample.new(category, data, response_config) }
    end

    def samples_for_sleep
      SleepSample.for_series(body['body']['series'], category, response_config)
    end

    def samples_for_workout
      body['body']['series'].map { |data| WorkoutSample.new(category, data, response_config) }
    end
  end
end
