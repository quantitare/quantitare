# frozen_string_literal: true

##
# Identifies the best {PlaceMatch} for a given location scrobble. It filters in two stages. First, it selects the
# matches that are a full match--that is, all traits listed in its +source_fields+ match the associated attributes
# on the scrobble. Second, it selects the match with the highest "specificity," which is defined on {PlaceMatch}.
#
class FindPlaceMatchForLocationScrobble
  include Callable

  attr_reader :location_scrobble, :query

  def initialize(location_scrobble, query: PlaceMatches::MatchingLocationScrobbleQuery)
    @location_scrobble = location_scrobble
    @query = query
  end

  def call
    query.(location_scrobble.user.place_matches, location_scrobble: location_scrobble)
      .max_by(&:specificity)
  end
end
