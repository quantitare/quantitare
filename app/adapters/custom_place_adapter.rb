# frozen_string_literal: true

##
# Entry point for finding and searching for custom places.
#
class CustomPlaceAdapter
  attr_reader :service

  def initialize(service = nil)
    @service = service
  end

  def find_places(longitude:, latitude:, query: '', radius: 0.5, limit: 25)
    results = ::Place.custom.near([longitude, latitude], radius, units: :km)

    results = query.present? ? results.where('places.name LIKE ?', query) : results

    results.sort_by(&:distance).first(limit)
  end

  def fetch_place(opts)
    ::Place.find_by(opts)
  end
end
