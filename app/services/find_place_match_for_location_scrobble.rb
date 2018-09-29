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
      fully_matches_place_match?(place_match)
    end
  end

  private

  def fully_matches_place_match?(place_match)
    place_match.source_fields.all? { |name, val| location_scrobble[name].to_s == val.to_s }
  end
end
