# frozen_string_literal: true

class ArcJSONAdapter
  ##
  # @private
  #
  class TimelineItem
    extend Memoist

    attr_reader :raw_item, :metadata_adapter

    def initialize(raw_item, metadata_adapter = Place.metadata_adapter)
      @raw_item = raw_item
      @metadata_adapter = metadata_adapter
    end

    def to_location_scrobble
      LocationScrobble.new(to_h)
    end

    def to_h
      {
        type: type,
        name: name,
        category: category,
        distance_traveled: distance_traveled,
        description: '',

        place: place,
        singular: singular?,

        trackpoints: trackpoints.map(&:to_h),

        start_time: start_time,
        end_time: end_time
      }
    end

    alias to_hash to_h

    def place?
      raw_item['isVisit']
    end

    def custom_place?
      place_service_identifier.blank?
    end

    def singular?
      place? && custom_place? && custom_title.present?
    end

    def type
      place? ? PlaceScrobble.name : TransitScrobble.name
    end

    def name
      place? ? place_name : raw_item['activityType']
    end

    def category
      place? ? '' : TRANSIT_CATEGORY_MAPPINGS[raw_item['activityType']]
    end

    def distance_traveled
      place? ? 0 : Util.distance_travelled_by_trackpoints(trackpoints)
    end

    def place
      return nil unless place?
      return nil if custom_place?

      Place.fetch(service_identifier: place_service_identifier, adapter: metadata_adapter)
    end

    def trackpoints
      raw_item['samples']
        .map { |sample| ArcJSONAdapter::Trackpoint.new(sample) }
        .reject { |trackpoint| trackpoint.primary_location_data.blank? }
    end

    memoize :trackpoints

    def start_time
      Time.zone.parse(raw_item['startDate'])
    end

    def end_time
      Time.zone.parse(raw_item['endDate'])
    end

    private

    def place_name
      raw_item.dig('place', 'name') ||
        custom_title ||
        raw_item['streetAddress']
    end

    def custom_title
      raw_item['customTitle']
    end

    def place_service_identifier
      raw_item.dig('place', 'foursquareVenueId')
    end
  end
end
