# frozen_string_literal: true

##
# Defines the workflow for creating a new {LocationScrobble}
#
class ProcessLocationScrobble
  include ApplicationOrganizer

  class << self
    def call(location_scrobble, save:, **options)
      with(location_scrobble: location_scrobble, save: save, options: options)
        .reduce(actions)
    end

    def actions
      [
        with_transaction([
          LocationScrobbles::HandleCollisions,

          reduce_if(->(ctx) { !ctx.skip }, [
            LocationScrobbles::ProcessScrobble,

            reduce_if(->(ctx) { ctx.location_scrobble.place? }, [
              MatchPlaceToLocationScrobble.actions
            ])
          ])
        ])
      ]
    end
  end
end
