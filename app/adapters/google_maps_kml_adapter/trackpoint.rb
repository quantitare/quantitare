# frozen_string_literal: true

class GoogleMapsKMLAdapter
  ##
  # Parses raw coordinates from Google Maps' KML export to the Trackpoint format accepted by LocationScrobble
  #
  class Trackpoint < ::Trackpoint
    class << self
      def parse_raw(raw_trackpoints)
        raw_trackpoints.split(' ').map do |raw_coords|
          lng, lat, alt = raw_coords.split(',').map(&:to_f)
          new(lng, lat, alt)
        end
      end
    end
  end
end
