# frozen_string_literal: true

module LocationScrobbles
  # @private
  class HandleCollisions
    extend LightService::Action

    expects :location_scrobble, :options
    promises :skip

    executed do |ctx|
      should_skip = false

      case ctx.options[:collision_mode]&.to_sym
      when :overwrite
        ctx.location_scrobble.user.location_scrobbles
          .overlapping_range(ctx.location_scrobble.start_time, ctx.location_scrobble.end_time)
          .destroy_all
      when :skip
        should_skip = true
      end

      ctx.skip = should_skip
    end
  end
end
