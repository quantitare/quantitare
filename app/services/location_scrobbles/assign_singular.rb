# frozen_string_literal: true

module LocationScrobbles
  # @private
  class AssignSingular
    include ApplicationAction

    expects :location_scrobble, :params

    executed do |ctx|
      ctx.location_scrobble.singular = ctx.params[:singular] if ctx.params.key?(:singular)

      ctx.location_scrobble.place = nil if ctx.location_scrobble.singular?
    end
  end
end
