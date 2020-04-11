# frozen_string_literal: true

class ArcJSONAdapter
  ##
  # @private
  #
  class Trackpoint
    include Storable

    store_reader :primary_location_data,
      :latitude, :longitude, :timestamp, :altitude, :course, :horizontal_accuracy, :speed

    attr_reader :raw_trackpoint

    def initialize(raw_trackpoint)
      @raw_trackpoint = raw_trackpoint
    end

    def to_h
      {
        latitude: latitude,
        longitude: longitude,
        timestamp: timestamp,
        altitude: altitude,
        speed: speed,
        course: course,
        horizontal_accuracy: horizontal_accuracy
      }
    end

    def primary_location_data
      raw_trackpoint['location']
    end
  end
end
