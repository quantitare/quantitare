# frozen_string_literal: true

module LocationImports
  # @private
  class AddScrobble
    extend LightService::Action

    expects :location_import, :location_scrobble

    executed do |ctx|
      ctx.location_scrobble.assign_attributes(user: ctx.location_import.user)
      ctx.location_import.location_scrobbles << ctx.location_scrobble
    end

    rolled_back do |ctx|
      ctx.location_scrobble.destroy
    end
  end
end
