# frozen_string_literal: true

##
# Entry point for finding and searching for custom places.
#
class CustomPlaceAdapter
  attr_reader :service

  def initialize(service = nil)
    @service = service
  end

  def find_places(longitude:, latitude:, query:, radius:, limit:)
    km_radius = radius / 1_000.0

    results = ::Place
      .custom
      .near([longitude, latitude], km_radius, units: :km)
      .limit(limit)

    query.present? ? results.where('places.name LIKE ?', query) : results
  end

  def fetch_place(opts)
    ::Place.find_by(opts)
  end
end
