# frozen_string_literal: true

##
# An adapter for dealing with a Google Maps KML file.
#
class GoogleMapsKMLAdapter
  include LocationImportable

  TRANSIT_CATEGORY_PATH = File.join(__dir__, 'google_maps_kml_adapter', 'transit_category_mappings.yml').freeze
  TRANSIT_CATEGORY_MAPPINGS = YAML.load_file(TRANSIT_CATEGORY_PATH).freeze

  class << self
    def importer_label
      'Google Maps KML'
    end
  end

  attr_reader :kml_file

  def initialize(kml_file)
    @kml_file = kml_file
  end

  def parsed_kml
    @parsed_kml ||= Nokogiri::XML(kml_file)
  end

  def location_scrobbles
    placemarks.map(&:to_location_scrobble)
  end

  alias scrobbles location_scrobbles

  def placemarks
    @placemarks ||= parsed_kml.css('kml Document Placemark').map do |xml_node|
      GoogleMapsKMLAdapter::Placemark.new(xml_node)
    end
  end
end
