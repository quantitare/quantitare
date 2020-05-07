# frozen_string_literal: true

module LocationScrobbles
  # @private
  class AssignPlaceId
    include ApplicationAction

    expects :location_scrobble, :params

    executed do |ctx|
      ctx.location_scrobble.place_id = ctx.params[:place_id] if ctx.params.key?(:place_id)

      ctx.skip_remaining! if ctx.location_scrobble.place_id_changed?
    end
  end
end
