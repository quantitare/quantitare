# frozen_string_literal: true

##
# Identifies the best {PlaceMatch} for a given location scrobble. It filters in two stages. First, it selects the
# matches that are a full match--that is, all traits listed in its +source_fields+ match the associated attributes
# on the scrobble. Second, it selects the match with the highest "specificity," which is defined on {PlaceMatch}.
#
class FindPlaceMatchForLocationScrobble
  include Callable

  attr_reader :location_scrobble

  def initialize(location_scrobble)
    @location_scrobble = location_scrobble
  end

  def call(query = PlaceMatches::MatchingLocationScrobbleQuery)
    query.(location_scrobble: location_scrobble)
      .max_by(&:specificity)
  end
end
