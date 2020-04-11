# frozen_string_literal: true

##
# This service finds a {PlaceMatch} related to the given {LocationScrobble}'s attributes and, if found, assigns the
# associated {Place} to the scrobble.
#
class MatchPlaceToLocationScrobble
  include ApplicationOrganizer

  class << self
    def call(location_scrobble, query: FindPlaceMatchForLocationScrobble, save: true, **options)
      with(location_scrobble: location_scrobble, save: save, query: query, options: options)
        .reduce(actions)
    end

    def actions
      [
        with_transaction([
          LocationScrobbles::FindPlaceMatch,
          LocationScrobbles::ProcessScrobble
        ])
      ]
    end
  end
end
