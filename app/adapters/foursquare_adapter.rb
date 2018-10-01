# frozen_string_literal: true

##
# API wrapper for the Foursquare service.
#
class FoursquareAdapter
  API_VERSION = '20180930'

  attr_reader :service

  delegate :user, to: :service

  def initialize(service)
    @service = service
  end

  def client
    @client ||= Foursquare2::Client.new(oauth_token: service.token, api_version: API_VERSION)
  end

  def find_place(longitude:, latitude:, query: '', radius: 250, limit: 25)
    results = client.search_venues(
      ll: "#{latitude},#{longitude}",
      query: query,
      radius: radius,
      intent: 'browse',
      limit: limit
    ).venues

    results.map { |venue| api_place_for_venue(venue).to_aux }
  end

  def fetch_place(opts = {})
    venue = client.venue(opts[:service_identifier])
    api_place_for_venue(venue).to_aux
  end

  private

  def api_place_for_venue(venue)
    FoursquareAdapter::Place.new(venue, service: service)
  end
end
