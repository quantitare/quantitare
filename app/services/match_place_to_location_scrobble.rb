# frozen_string_literal: true

##
# This service finds a {PlaceMatch} related to the given {LocationScrobble}'s attributes and, if found, assigns the
# associated {Place} to the scrobble.
#
class MatchPlaceToLocationScrobble
  include Serviceable

  attr_reader :location_scrobble, :query

  transactional!

  def initialize(location_scrobble, query: FindPlaceMatchForLocationScrobble)
    @location_scrobble = location_scrobble
    @query = query
  end

  def call
    step :process_place_match

    result.set(location_scrobble: location_scrobble)
  end

  private

  def process_place_match
    return if matching_place_match.blank?

    location_scrobble.update(place: matching_place_match.place)

    result.errors += location_scrobble.errors.full_messages
  end

  def matching_place_match
    @matching_place_match ||= query.(location_scrobble)
  end
end
