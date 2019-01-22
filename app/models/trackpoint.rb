# frozen_string_literal: true

##
# A simple universal Trackpoint struct.
#
class Trackpoint
  attr_reader :latitude, :longitude, :altitude, :timestamp

  def initialize(latitude, longitude, altitude = nil, timestamp = nil)
    @latitude = latitude
    @longitude = longitude
    @altitude = altitude
    @timestamp = timestamp
  end

  def to_h
    { latitude: latitude, longitude: longitude, altitude: altitude, timestamp: timestamp }
  end

  alias to_hash to_h
end
