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
        overlapping_scrobbles(ctx).destroy_all
      when :skip
        should_skip = overlapping_scrobbles(ctx).exists?
      end

      ctx.skip = should_skip
    end

    class << self
      def overlapping_scrobbles(ctx)
        ctx.location_scrobble.user.location_scrobbles
          .overlapping_range(ctx.location_scrobble.start_time, ctx.location_scrobble.end_time)
          .where.not(id: ctx.location_scrobble.id)
          .where.not(source: ctx.location_scrobble.source)
      end
    end
  end
end
