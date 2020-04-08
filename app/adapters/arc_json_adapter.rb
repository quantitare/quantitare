# frozen_string_literal: true

##
# An adapter for dealing with an Arc JSON export
#
class ArcJSONAdapter
  include LocationImportable

  class << self
    def importer_label
      'Arc JSON'
    end
  end

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def location_scrobbles
    timeline_items.map(&:to_location_scrobble)
  end

  def timeline_items
    @timeline_items ||= parsed_json['timelineItems'].map { |raw_item| ArcJSONAdapter::TimelineItem.new(raw_item) }
  end

  def parsed_json
    @parsed_json ||= JSON.parse(file.read)
  end
end
