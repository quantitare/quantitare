# frozen_string_literal: true

##
# API wrapper for the Rescuetime API
#
class RescuetimeAdapter
  attr_reader :service

  def initialize(service)
    @service = service
  end

  def client
    @client ||= Rescuetime::Client.new(api_key: service.token)
  end

  def fetch_scrobbles(start_time, end_time)
    fetch_activities(start_time, end_time)
      .map { |data| RescuetimeAdapter::Scrobble.from_api(data) }
      .select { |scrobble| (start_time..end_time).overlaps?(scrobble.start_time..scrobble.end_time) }
  end

  def fetch_activities(start_time, end_time)
    catch_api_errors do
      client.activities.from(start_time.to_s).to(end_time.to_s).order_by(:time, interval: :minute).all
    end
  end

  private

  def invalid_credentials_message
    "Invalid credentials for service #{service.name}"
  end

  def missing_credentials_message
    "Missing credentials for service #{service.name}"
  end

  def invalid_request_message
    "#{self.class.name} made an invalid request to service #{service.name}"
  end

  def catch_api_errors
    yield if block_given?
  rescue Rescuetime::Errors::MissingCredentialsError
    raise Errors::ServiceConfigError.new(missing_credentials_message, nature: :user_token)
  rescue Rescuetime::Errors::InvalidCredentialsError
    raise Errors::ServiceConfigError.new(invalid_credentials_message, nature: :user_token)
  rescue Rescuetime::Errors::TooManyRequests, Rescuetime::Errors::ServerError
    raise Errors::ServiceAPIError
  rescue Rescuetime::Errors::InvalidQueryError, Rescuetime::Errors::InvalidFormatError, Rescuetime::Errors::ClientError
    raise Errors::ServiceConfigError.new(invalid_request_message, nature: :request_format)
  end
end
