# frozen_string_literal: true

module LocationScrobbles
  # @private
  class AssignPlaceAttributes
    include ApplicationAction

    expects :location_scrobble, :params

    executed do |ctx|
      ctx.location_scrobble.place_attributes = ctx.params[:place_attributes]
      ctx.location_scrobble.place.user = ctx.location_scrobble.user if ctx.location_scrobble.place.new_record?
    end
  end
end
