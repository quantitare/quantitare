# frozen_string_literal: true

##
#
#
class PointScrobble < Scrobble
  before_validation :set_timestamps

  def timestamp
    @timestamp ||= init_timestamp
  end

  def timestamp=(value)
    attribute_will_change!('timestamp') if timestamp != value
    @timestamp = value
  end

  def timestamp_changed?
    changed.include?('timestamp')
  end

  private

  def set_timestamps
    return unless timestamp_changed?

    self.start_time = self.end_time = timestamp
  end

  def init_timestamp
    start_time
  end
end
