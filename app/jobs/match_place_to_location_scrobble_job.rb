# frozen_string_literal: true

##
# This job finds a {PlaceMatch} related to the given {LocationScrobble}'s attributes and, if found, assigns the
# associated {Place} to the scrobble.
#
class MatchPlaceToLocationScrobbleJob < ApplicationJob
  queue_as :default

  attr_reader :location_scrobble

  def perform(location_scrobble)
    @location_scrobble = location_scrobble

    process_place_match!
  end

  private

  def process_place_match!
    location_scrobble.update!(place: matching_place_match.place) if matching_place_match
  end

  def matching_place_match
    @matching_place_match ||= FindPlaceMatchForLocationScrobble.(location_scrobble)
  end
end
