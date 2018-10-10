# frozen_string_literal: true

##
# This service finds a {PlaceMatch} related to the given {LocationScrobble}'s attributes and, if found, assigns the
# associated {Place} to the scrobble.
#
class MatchPlaceToLocationScrobble
  include Serviceable

  attr_reader :location_scrobble, :query, :save

  transactional!

  def initialize(location_scrobble, query: FindPlaceMatchForLocationScrobble, save: true)
    @location_scrobble = location_scrobble
    @query = query
    @save = save
  end

  def call
    step :set_place_match
    step :save_location_scrobble

    result.set(location_scrobble: location_scrobble)
  end

  private

  def set_place_match
    return if matching_place_match.blank?

    location_scrobble.place = matching_place_match.place
  end

  def save_location_scrobble
    return unless save

    location_scrobble.save

    result.errors += location_scrobble.errors.full_messages
  end

  def matching_place_match
    @matching_place_match ||= query.(location_scrobble)
  end
end
