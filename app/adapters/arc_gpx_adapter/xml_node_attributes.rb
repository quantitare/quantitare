# frozen_string_literal: true

require_dependency 'arc_gpx_adapter/placemark'
require_dependency 'arc_gpx_adapter/trackpoint'

class ArcGPXAdapter
  ##
  # Extracts attributes from a GPX XML node.
  #
  class XMLNodeAttributes
    include Util::XMLNodeTools

    attr_reader :xml_node

    def initialize(xml_node)
      @xml_node = xml_node
    end

    def type
      case xml_node.name
      when 'wpt'
        ArcGPXAdapter::Placemark::T_PLACE
      when 'trk'
        ArcGPXAdapter::Placemark::T_TRANSIT
      end
    end

    def name
      value_from_xml_path(xml_node, 'name')
    end

    def category
      case type
      when ArcGPXAdapter::Placemark::T_PLACE
        nil
      when ArcGPXAdapter::Placemark::T_TRANSIT
        _category
      end
    end

    def distance
      return 0 if trackpoints.length.zero? || type == ArcGPXAdapter::Placemark::T_PLACE

      interlinked_trackpoint_pairs.sum do |pair|
        Util.distance_between_trackpoints(*pair)
      end
    end

    def trackpoints(trackpoint_klass = ArcGPXAdapter::Trackpoint)
      case type
      when ArcGPXAdapter::Placemark::T_PLACE
        [trackpoint_klass.from_xml_node(xml_node)]
      when ArcGPXAdapter::Placemark::T_TRANSIT
        xml_node.css('trkseg trkpt').map { |trkpt_node| trackpoint_klass.from_xml_node(trkpt_node) }
      end
    end

    private

    def _category
      TRANSIT_CATEGORY_MAPPINGS[raw_category]
    end

    def raw_category
      value_from_xml_path(xml_node, 'type')
    end

    def interlinked_trackpoint_pairs
      trackpoints.map.with_index do |trackpoint1, idx|
        trackpoint2 = trackpoints[idx + 1]
        return nil if trackpoint2.blank?

        [trackpoint1, trackpoint2]
      end.compact
    end
  end
end
