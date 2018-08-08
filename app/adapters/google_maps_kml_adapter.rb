# frozen_string_literal: true

##
# An adapter for dealing with a Google Maps KML file.
#
class GoogleMapsKmlAdapter
  include LocationImportable

  class << self
    def importer_label
      'Google Maps KML'
    end

    def load_file_contents(contents)
      new(contents)
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

  def placemarks
    @placemarks ||= parsed_kml.css('kml Document Placemark').map do |xml_node|
      GoogleMapsKmlAdapter::Placemark.new(xml_node)
    end
  end
end
