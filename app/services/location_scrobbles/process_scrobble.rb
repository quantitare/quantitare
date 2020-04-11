# frozen_string_literal: true

module LocationScrobbles
  # @private
  class ProcessScrobble
    extend LightService::Action

    expects :location_scrobble, :save

    executed do |ctx|
      success = ctx.save ? ctx.location_scrobble.save : ctx.location_scrobble.valid?

      ctx.fail!('Could not validate Location Scrobble') unless success
    end
  end
end
