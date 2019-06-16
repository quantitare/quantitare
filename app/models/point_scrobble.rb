# frozen_string_literal: true

##
#
#
class PointScrobble < Scrobble
  validate :start_time_and_end_time_must_be_equal

  private

  def start_time_and_end_time_must_be_equal
    errors[:base] << 'start time and end time must be equal to each other' unless start_time == end_time
  end
end
