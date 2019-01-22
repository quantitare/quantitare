# frozen_string_literal: true

class GoogleMapsKmlAdapter
  ##
  # Parses raw coordinates from Google Maps' KML export to the Trackpoint format accepted by LocationScrobble
  #
  class Trackpoint < ::Trackpoint
    class << self
      def parse_raw(raw_trackpoints)
        raw_trackpoints.split(' ').map do |raw_coords|
          lat, lng, alt = raw_coords.split(',').map(&:to_f)
          new(lat, lng, alt)
        end
      end
    end
  end
end
