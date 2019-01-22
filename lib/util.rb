# frozen_string_literal: true

##
# General-purpose methods for common simple tasks.
#
module Util
  class << self
    def distance_between_trackpoints(trackpoint1, trackpoint2)
      pair = [trackpoint1, trackpoint2]
      normalized_pair = pair.map { |trackpoint| [trackpoint.latitude, trackpoint.longitude] }
      Geocoder::Calculations.distance_between(normalized_pair[0], normalized_pair[1])
    end
  end
end
