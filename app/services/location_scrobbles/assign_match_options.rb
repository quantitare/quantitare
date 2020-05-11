# frozen_string_literal: true

module LocationScrobbles
  # @private
  class AssignMatchOptions
    include ApplicationAction

    expects :location_scrobble, :params

    executed do |ctx|
      ctx.location_scrobble.match_options_attributes = ctx.params[:match_options_attributes]
      ctx.location_scrobble.match_options.place = ctx.location_scrobble.place
    end
  end
end
