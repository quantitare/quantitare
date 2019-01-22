# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Parses GPX nodes into generic trackpoints
  #
  class Trackpoint < ::Trackpoint
    extend Util::XMLNodeTools

    # rubocop:disable Rails/Date
    class << self
      def from_xml_node(xml_node)
        lat = value_from_xml_node_attributes(xml_node, 'lat').to_f
        lon = value_from_xml_node_attributes(xml_node, 'lon').to_f
        ele = value_from_xml_path(xml_node, 'ele').to_f
        time = value_from_xml_path(xml_node, 'time').to_time

        new(lat, lon, ele, time)
      end
    end
    # rubocop:enable Rails/Date
  end
end
