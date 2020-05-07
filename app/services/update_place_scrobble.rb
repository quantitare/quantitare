# frozen_string_literal: true

##
# Updates a {LocationScrobble} object in stages, based on a given set of HTTP parametrs. This allows us to safely
# receive any parameters from the client from a subset of "accepted" parameters without needing to worry about invalid
# states. For example, marking a {LocationScrobble} as +singular+ should cause it to reject any nested
# +place_attributes+ parameters, since a +singular+ scrobble should never have a place attached.
#
class UpdatePlaceScrobble
  include ApplicationOrganizer

  class << self
    def call(location_scrobble:, params:, save:)
      with(location_scrobble: location_scrobble, params: params, save: save).reduce(actions)
    end

    def actions
      [
        LocationScrobbles::AssignSingular,

        reduce_if(->(ctx) { !ctx.location_scrobble.singular? }, [
          LocationScrobbles::AssignPlaceId,
          LocationScrobbles::AssignPlaceAttributes
        ]),

        reduce_if(->(ctx) { !ctx.location_scrobble.singular? && ctx.location_scrobble.place.present? }, [
          LocationScrobbles::AssignMatchOptions
        ]),

        LocationScrobbles::ProcessScrobble,
        ProcessPlaceMatchOptions.actions
      ]
    end
  end
end
