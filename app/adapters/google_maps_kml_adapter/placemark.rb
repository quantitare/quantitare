# frozen_string_literal: true

class GoogleMapsKmlAdapter
  ##
  # Converts a single placemark XML node from a KML document to a {LocationScrobble}.
  #
  class Placemark
    attr_reader :xml_node

    def initialize(xml_node)
      @xml_node = xml_node
    end

    def to_location_scrobble
      LocationScrobble.new(to_h)
    end

    def to_h
      {
        type: type,
        name: name,
        category: category,
        distance: distance,
        description: description,

        trackpoints: trackpoints.map(&:to_h),
        place: place,

        start_time: start_time,
        end_time: end_time
      }
    end

    alias to_hash to_h

    def type
      distance.zero? ? PlaceScrobble.name : TransitScrobble.name
    end

    def name
      value_from_path('name')
    end

    def category
      value_from_path('ExtendedData Data[name="Category"] value')
    end

    def distance
      value_from_path('ExtendedData Data[name="Distance"] value').to_f
    end

    def description
      value_from_path('description')
    end

    def trackpoints
      GoogleMapsKmlAdapter::Trackpoint.parse_raw(raw_trackpoints)
    end

    def raw_trackpoints
      if value_exists?('Point coordinates')
        value_from_path('Point coordinates')
      else
        value_from_path('LineString coordinates')
      end
    end

    # TODO
    def place
      nil
    end

    def start_time
      Time.zone.parse(value_from_path('TimeSpan begin'))
    end

    def end_time
      Time.zone.parse(value_from_path('TimeSpan end'))
    end

    private

    def value_exists?(css_selector)
      xml_node.at_css(css_selector).present?
    end

    def value_from_path(css_selector)
      xml_node.at_css(css_selector).text
    end
  end
end
