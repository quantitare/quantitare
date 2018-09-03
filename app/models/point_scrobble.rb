# frozen_string_literal: true

##
#
#
class PointScrobble < Scrobble
  validate :start_time_and_end_time_must_be_equal

  def timestamp
    @timestamp ||= init_timestamp
  end

  def timestamp=(value)
    @timestamp = value
    set_timestamps
  end

  def timestamp_changed?
    changed.include?('timestamp')
  end

  private

  def start_time_and_end_time_must_be_equal
    errors[:base] << 'start time and end time must be equal to each other' unless start_time == end_time
  end

  def set_timestamps
    self.start_time = self.end_time = timestamp
  end

  def init_timestamp
    start_time
  end
end
