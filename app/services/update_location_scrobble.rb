# frozen_string_literal: true

##
# Update a given location scrobble based on the given parameters.
#
class UpdateLocationScrobble
  include ApplicationOrganizer

  class << self
    def call(location_scrobble:, params:, **kwargs)
      with(location_scrobble: location_scrobble, params: params, **kwargs).reduce(actions)
    end

    def actions
      [
        reduce_if(->(ctx) { ctx[:location_scrobble].place? }, UpdatePlaceScrobble.actions)
      ]
    end
  end
end
