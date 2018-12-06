# frozen_string_literal: true

##
# An adapter for dealing with GPX-formatted data from the Arc location tracking app.
#
class ArcGPXAdapter
  include LocationImportable

  class << self
    def importer_label
      'Arc App GPX'
    end
  end

  attr_reader :gpx_file

  def initialize(gpx_file)
    @gpx_file = gpx_file
  end

  def parsed_gpx
    @parsed_gpx ||= Nokogiri::XML(gpx_file)
  end

  def location_scrobbles
    placemarks.map(&:to_location_scrobble)
  end

  def placemarks
    @placemarks ||= ArcGPXAdapter::Placemark.from_xml_nodes(xml_nodes)
  end

  private

  def xml_nodes
    @xml_nodes ||= parsed_gpx.css('gpx wpt,gpx trk')
  end
end

require_dependency 'arc_gpx_adapter/placemark'
