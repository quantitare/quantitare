# frozen_string_literal: true

module PlaceMatchOptions
  # @private
  class Enable
    include ApplicationAction

    expects :location_scrobble
    promises :place_match

    executed do |ctx|
      success = ctx.location_scrobble.match_options.save
      ctx.place_match = ctx.location_scrobble.place_match

      ctx.fail! 'Could not enable match options' unless success
    end

    rolled_back do |ctx|
      ctx.location_scrobble.match_options.destroy
    end
  end
end
