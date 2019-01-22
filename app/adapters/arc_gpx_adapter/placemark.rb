# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Converts a single placemark XML node from a Arc GPX document to a new {LocationScrobble} record.
  #
  class Placemark
    T_TRANSIT = TransitScrobble.name.freeze
    T_PLACE = PlaceScrobble.name.freeze

    attr_reader :attributes

    delegate :type, :name, :category, :distance, :description, :trackpoints, :start_time, :end_time, to: :attributes

    class << self
      def from_xml_nodes(xml_nodes)
        final = []
        current_bundle = ArcGPXAdapter::Bundle.new

        xml_nodes.each do |xml_node|
          placemark = from_xml_node(xml_node)

          unless current_bundle.can_absorb?(placemark)
            final << new(attributes: current_bundle.compile)
            current_bundle = ArcGPXAdapter::Bundle.new
          end

          current_bundle << placemark
        end

        final
      end

      def from_xml_node(xml_node)
        new(attributes: ArcGPXAdapter::XMLNodeAttributes.new(xml_node))
      end
    end

    def initialize(attributes:)
      @attributes = attributes
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

    def transit?
      type == T_TRANSIT
    end

    def place?
      type == T_PLACE
    end
  end
end
