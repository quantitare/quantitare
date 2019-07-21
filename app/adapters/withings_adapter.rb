# frozen_string_literal: true

##
# An API wrapper for the Withings Healthmate service. Attempts to intelligently consolidate fetches into as few
# requests as possible.
#
class WithingsAdapter
  API_URL = 'https://wbsapi.withings.net/v2'
  ACCOUNT_URL = 'https://account.withings.com/oauth2/token'
  CATEGORY_CONFIGS = YAML.safe_load(
    File.read(Rails.root.join('app', 'adapters', 'withings_adapter', 'category_configs.yml')),
    [Symbol]
  ).freeze
  ENDPOINT_CONFIGS = YAML.safe_load(
    File.read(Rails.root.join('app', 'adapters', 'withings_adapter', 'endpoint_configs.yml')),
    [Symbol]
  ).freeze

  attr_reader :service, :refresher

  delegate :user, :token, to: :service

  def initialize(service, refresher: WithingsAdapter::ServiceRefresh.new(service))
    @service = service
    @refresher = refresher
  end

  # The pre-configured Faraday HTTP client. This cannot be memoized since the token might change throughout the
  # lifespan of this object.
  #
  # @return [#get] an HTTP client that can be used to fetch a payload from the Withings API, pre-loaded with
  #   authentication headers and everything else needed to authenticate with the API
  def http_client
    Faraday.new(url: API_URL) do |conn|
      conn.request :oauth2, token, token_type: :bearer
      conn.response :json

      conn.adapter Faraday.default_adapter
    end
  end

  # @param start_time [Time] the earliest time you wish to fetch data for
  # @param end_time [Time] the lastest time you wish to fetch data for. May be subject to constraints imposed by the
  #   Withings API
  # @param categories [Array<String>] all of the categories you wish to fetch data for
  # @param cadence [ActiveSupport::Duration, Numeric] the amount of time to wait between requests
  # @return [Array<Scrobble>] a collection of scrobbles that can be passed into {Scrobbler#fetch_scrobble}
  def fetch_scrobbles(start_time, end_time, categories: [], cadence: 0.seconds)
    scrobbles = []

    requests_for_categories(categories, start_time, end_time).each do |request|
      responses = responses_for_request(request, cadence: cadence).compact

      scrobbles += responses.flat_map { |response| scrobbles_for_response(response, request) }

      sleep cadence
    end

    scrobbles.compact
  end

  def requests_for_categories(categories, start_time, end_time)
    WithingsAdapter::Request.for_categories(categories, start_time, end_time)
  end

  def responses_for_request(request, cadence: 0.seconds)
    responses = [fetch(request)]

    while more_data_for_request?(request, responses.last)
      sleep cadence

      request.increment_offset!
      responses << fetch(request)
    end

    responses
  end

  def fetch(request)
    service.with_lock { refresh_service! if service.expired?(60.minutes.from_now) }
    raise Errors::ServiceConfigError.new(issue_reported: true) if service.issues?

    http_client.get("#{request.path}?#{request.params.to_query}")
  rescue Faraday::TimeoutError
    raise Errors::ServiceAPIError, "Request to service #{service.name} timed out"
  end

  def scrobbles_for_response(response, request)
    WithingsAdapter::Scrobble.from_api(response, request)
  end

  def refresh_service!
    refresher.process!
  end

  private

  def more_data_for_request?(request, response)
    return false if response.blank? || !response.success?

    request.paged? && response.body.dig('body', 'more')
  end
end

require_relative 'withings_adapter/scrobble'
