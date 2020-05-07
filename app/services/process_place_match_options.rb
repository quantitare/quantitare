# frozen_string_literal: true

##
# Takes a {LocationScrobble} object and parses its +match_options+ object, taking action depending on what has been
# inputted.
#
class ProcessPlaceMatchOptions
  include ApplicationOrganizer

  class << self
    def call(location_scrobble:)
      with(location_scrobble: location_scrobble).reduce(actions)
    end

    def actions
      [
        reduce_if(->(ctx) { ctx.location_scrobble.match_options.to_delete? }, [
          PlaceMatchOptions::Destroy
        ]),

        reduce_if(->(ctx) {
          !ctx.location_scrobble.match_options.destroyed? && ctx.location_scrobble.match_options.enabled?
        }, [
          PlaceMatchOptions::Enable,
          PlaceMatches::ProcessExistingLocationScrobbles
        ])
      ]
    end
  end
end
