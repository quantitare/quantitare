# frozen_string_literal: true

##
# General-purpose methods for common simple tasks.
#
module Util
  class << self
    def distance_travelled_by_trackpoints(*trackpoints)
      linked_pairs(trackpoints).sum { |pair| distance_between_trackpoints(*pair) }
    end

    def distance_between_trackpoints(trackpoint1, trackpoint2)
      pair = [trackpoint1, trackpoint2]
      normalized_pair = pair.map { |trackpoint| [trackpoint.latitude, trackpoint.longitude] }
      Geocoder::Calculations.distance_between(normalized_pair[0], normalized_pair[1])
    end

    def linked_pairs(array)
      array[0...-1].map.with_index { |val, idx| [val, array[idx + 1]] }
    end

    def sanitize_encoding(str)
      str.encode('UTF-8', invalid: :replace, undef: :replace, replace: '_')
    end
  end
end
