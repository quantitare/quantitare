# frozen_string_literal: true

module LocationScrobbles
  # @private
  class FindPlaceMatch
    include ApplicationAction

    expects :location_scrobble
    promises :query

    executed do |ctx|
      merge_default(ctx, :query, FindPlaceMatchForLocationScrobble)

      matching_place_match = ctx.query.(ctx.location_scrobble)
      next ctx if matching_place_match.blank?

      ctx.location_scrobble.place = matching_place_match.place
    end
  end
end
