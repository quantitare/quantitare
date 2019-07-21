# frozen_string_literal: true

##
# API wrapper for the Twitter API
#
class TwitterAdapter
  USER_TOKEN_ERRORS = [
    Twitter::Error::Unauthorized, Twitter::Error::Forbidden
  ].freeze

  REQUEST_FORMAT_ERRORS = [
    Twitter::Error::BadRequest, Twitter::Error::RequestEntityTooLarge, Twitter::Error::NotAcceptable,
    Twitter::Error::UnprocessableEntity
  ].freeze

  GENERAL_ERRORS = [
    Twitter::Error::NotFound
  ].freeze

  API_ERRORS = [
    Twitter::Error::TooManyRequests, Twitter::Error::InternalServerError, Twitter::Error::BadGateway,
    Twitter::Error::ServiceUnavailable, Twitter::Error::GatewayTimeout, HTTP::ConnectionError
  ].freeze

  attr_reader :service

  def initialize(service)
    @service = service
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key = service.provider_key
      config.consumer_secret = service.provider_secret

      config.access_token = service.token
      config.access_token_secret = service.secret
    end
  end

  def fetch_scrobbles(start_time, end_time, cadence: 0.seconds)
    fetch_tweets(start_time, end_time, cadence: cadence)
      .uniq(&:id)
      .map { |raw_tweet| TwitterAdapter::Scrobble.from_api(raw_tweet) }
  end

  def fetch_tweets(start_time, end_time, cadence: 0.seconds, max_id: nil, tweets: [])
    tweets_from_source = catch_api_errors { client.user_timeline(username, timeline_opts(max_id: max_id)) }
    parsed_tweets, done = parse_tweets_from_source(tweets_from_source, start_time, end_time)
    tweets += parsed_tweets

    return tweets if done

    sleep cadence

    fetch_tweets(start_time, end_time, cadence: cadence, max_id: tweets_from_source.last.id, tweets: tweets)
  end

  def username
    service.options['name']
  end

  private

  def catch_api_errors
    yield if block_given?
  rescue *USER_TOKEN_ERRORS
    raise Errors::ServiceConfigError.new(user_token_error_message, nature: :user_token)
  rescue *REQUEST_FORMAT_ERRORS
    raise Errors::ServiceConfigError.new(request_format_error_message, nature: :request_format)
  rescue *GENERAL_ERRORS
    raise Errors::ServiceConfigError.new("#{service.name} returned an unknown error", nature: :general)
  rescue *API_ERRORS
    raise Errors::ServiceAPIError
  end

  def user_token_error_message
    "Invalid authorization for service #{service.name}. Please reauthorize with Twitter."
  end

  def request_format_error_message
    "#{self.class.name} made an invalid request to #{service.name}"
  end

  def parse_tweets_from_source(tweets, start_time, end_time)
    results = tweets.select { |tweet| tweet.created_at.between?(start_time, end_time) }
    done = tweets.last.created_at < start_time || tweets.length <= 1

    [results, done]
  end

  def timeline_opts(max_id: nil)
    base_opts = { include_rts: true }

    base_opts[:max_id] = max_id if max_id

    base_opts
  end
end

require_dependency 'twitter_adapter/scrobble'
