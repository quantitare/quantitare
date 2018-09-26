# frozen_string_literal: true

##
# This job finds location scrobbles whose attributes match the attributes specified by the provided {PlaceMatch} and
# assigns them the specified {Place}.
#
class MatchLocationScrobblesToPlaceMatchJob < ApplicationJob
  queue_as :default

  def perform(place_match)
    place_match.matching_location_scrobbles.each do |location_scrobble|
      location_scrobble.update(place: place_match.place)
    end
  end
end
