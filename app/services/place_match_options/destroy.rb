# frozen_string_literal: true

module PlaceMatchOptions
  # @private
  class Destroy
    include ApplicationAction

    expects :location_scrobble

    executed do |ctx|
      success = ctx.location_scrobble.match_options.destroy

      ctx.fail! 'Unable to disable the place match' unless success
    end
  end
end
