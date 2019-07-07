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
    fetch_activities(start_time, end_time).map { |data| RescuetimeAdapter::Scrobble.from_api(data) }
  end

  def fetch_activities(start_time, end_time)
    client.activities
      .from(start_time.to_s).to(end_time.to_s)
      .order_by(:time, interval: :minute)
  end
end

require_dependency 'rescuetime_adapter/scrobble'
