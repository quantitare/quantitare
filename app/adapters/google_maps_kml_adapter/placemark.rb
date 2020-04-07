# frozen_string_literal: true

class GoogleMapsKMLAdapter
  ##
  # Converts a single placemark XML node from a KML document to a {LocationScrobble}.
  #
  class Placemark
    include Util::XMLNodeTools

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

        start_time: start_time,
        end_time: end_time
      }
    end

    alias to_hash to_h

    def type
      distance.zero? ? PlaceScrobble.name : TransitScrobble.name
    end

    def name
      value_from_xml_path(xml_node, 'name')
    end

    def category
      process_input_category(raw_category)
    end

    def distance
      value_from_xml_path(xml_node, 'ExtendedData Data[name="Distance"] value').to_f
    end

    def description
      value_from_xml_path(xml_node, 'description')
    end

    def trackpoints
      GoogleMapsKMLAdapter::Trackpoint.parse_raw(raw_trackpoints)
    end

    def raw_trackpoints
      if xml_value_exists?(xml_node, 'Point coordinates')
        value_from_xml_path(xml_node, 'Point coordinates')
      else
        value_from_xml_path(xml_node, 'LineString coordinates')
      end
    end

    def start_time
      Time.zone.parse(value_from_xml_path(xml_node, 'TimeSpan begin'))
    end

    def end_time
      Time.zone.parse(value_from_xml_path(xml_node, 'TimeSpan end'))
    end

    private

    def xml_value_exists?(xml_node, css_selector)
      xml_node.at_css(css_selector).present?
    end

    def raw_category
      value_from_xml_path(xml_node, 'ExtendedData Data[name="Category"] value')
    end

    def process_input_category(input_category)
      if type == PlaceScrobble.name
        input_category
      else
        TRANSIT_CATEGORY_MAPPINGS[input_category.downcase]
      end
    end
  end
end
