# frozen_string_literal: true

##
# Identifies the best location
#
class FindPlaceMatchForLocationScrobble
  include Callable

  attr_reader :location_scrobble

  def initialize(location_scrobble)
    @location_scrobble = location_scrobble
  end

  def call
    PlaceMatches::MatchingLocationScrobbleQuery.(location_scrobble: location_scrobble).find do |place_match|
      matches_place_match?(place_match)
    end
  end

  def matches_place_match?(place_match)
    place_match.source_fields.all? { |name, val| location_scrobble[name].to_s == val.to_s }
  end
end
