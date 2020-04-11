# frozen_string_literal: true

##
# API wrapper for the Foursquare service.
#
class FoursquareAdapter
  API_VERSION = '20180930'

  attr_reader :service

  delegate :user, :provider, to: :service

  def initialize(service)
    @service = service
  end

  def client
    @client ||= Foursquare2::Client.new(oauth_token: service.token, api_version: API_VERSION)
  end

  def search_places(longitude:, latitude:, query:, radius:, limit:)
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
    raw_venue = client.venue(opts[:service_identifier])

    api_place_for_venue(raw_venue, target_identifier: opts[:service_identifier]).to_aux
  end

  def fetch_place_category_list(_opts = {})
    raw_place_category_list = client.venue_categories

    FoursquareAdapter::PlaceCategoryList.new(raw_place_category_list, service: service).to_aux
  end

  def fetch_place_category(opts = {})
    category_list = Aux::PlaceCategoryList.fetch(adapter: self, provider: service.provider)
    raw_category = category_list.categories[opts[:id]]

    raw_category.present? ? FoursquareAdapter::PlaceCategory.new(raw_category, service: service).to_aux : nil
  end

  private

  def api_place_for_venue(venue, target_identifier: nil)
    FoursquareAdapter::Place.new(venue, target_identifier: target_identifier, service: service)
  end
end
