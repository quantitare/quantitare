# frozen_string_literal: true

##
# An API wrapper for the Trakt.tv service.
#
class TraktAdapter
  Request = Struct.new(:path, :params)
  Response = Struct.new(:body, :status, :success, :page, :page_count) do
    def success?
      success
    end
  end

  API_URL = 'https://api.trakt.tv'
  CATEGORY_MAPPINGS = { tv: 'episode', movie: 'movie' }.freeze

  attr_reader :service

  delegate :user, :token, to: :service

  def initialize(service)
    @service = service
  end

  def http_client
    Faraday.new(url: API_URL, headers: http_client_headers) do |conn|
      conn.request :oauth2, token, token_type: :bearer
      conn.response :json

      conn.adapter Faraday.default_adapter
    end
  end

  def fetch_scrobbles(start_time, end_time, categories: CATEGORY_MAPPINGS.keys, cadence: 0.seconds)
    responses = [fetch(request_for_history(start_time, end_time))]

    while more_pages?(responses.last)
      sleep cadence

      responses << fetch(request_for_history(start_time, end_time, page: responses.last.page_count))
    end

    responses.flat_map { |response| scrobbles_for_response(response, categories: categories) }
  end

  def fetch(request)
    response = parse_response(http_client.get("#{request.path}?#{(request.params || {}).to_query}"))

    verify_response(response)

    response
  rescue Faraday::TimeoutError
    raise Errors::ServiceAPIError, "Request to service #{service.name} timed out"
  end

  private

  def request_for_history(start_time, end_time, page: 0)
    Request.new('/users/me/history', start_at: start_time.iso8601, end_at: end_time.iso8601, page: page)
  end

  def parse_response(http_response)
    Response.new(
      http_response.body,
      http_response.status,
      http_response.success?,
      http_response.headers['X-Pagination-Page'],
      http_response.headers['X-Pagination-Page-Count']
    )
  end

  def verify_response(response)
    TraktAdapter::ResponseVerifier.new(response).process!
  end

  def more_pages?(response)
    response.page < response.page_count
  end

  def scrobbles_for_response(response, categories: CATEGORY_MAPPINGS.keys)
    TraktAdapter::Scrobble.from_api(response, categories: categories)
  end

  def http_client_headers
    {
      'Content-Type' => 'application/json',
      'trakt-api-key' => ENV['TRAKT_OAUTH_KEY'],
      'trakt-api-version' => '2'
    }
  end
end

require_relative 'trakt_adapter/scrobble'
