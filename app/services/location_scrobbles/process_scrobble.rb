# frozen_string_literal: true

module LocationScrobbles
  # @private
  class ProcessScrobble
    include ApplicationAction

    expects :location_scrobble
    promises :save

    executed do |ctx|
      merge_default(ctx, :save, false)

      success = ctx.save ? ctx.location_scrobble.save : ctx.location_scrobble.valid?

      ctx.fail!('Could not validate Location Scrobble') unless success
    end
  end
end
