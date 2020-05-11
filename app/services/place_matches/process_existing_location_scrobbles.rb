# frozen_string_literal: true

module PlaceMatches
  # @private
  class ProcessExistingLocationScrobbles
    include ApplicationAction

    expects :place_match

    executed do |ctx|
      MatchLocationScrobblesToPlaceMatchJob.perform_later(ctx.place_match)
    end
  end
end
