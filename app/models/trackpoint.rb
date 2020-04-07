# frozen_string_literal: true

##
# A simple universal Trackpoint struct.
#
class Trackpoint
  attr_reader :longitude, :latitude, :altitude, :timestamp

  def initialize(longitude, latitude, altitude = nil, timestamp = nil)
    @longitude = longitude
    @latitude = latitude
    @altitude = altitude
    @timestamp = timestamp
  end

  def to_h
    { latitude: latitude, longitude: longitude, altitude: altitude, timestamp: timestamp }
  end

  alias to_hash to_h
end
