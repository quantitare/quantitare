# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :source, polymorphic: true

  before_save :set_period

  default_scope -> { order(start_time: :asc) }
  scope :overlapping_range, ->(from, to) { where('location_scrobbles.period && ?', "[#{from},#{to}]") }

  def place?
    is_a? PlaceScrobble
  end

  def transit?
    is_a? TransitScrobble
  end

  def friendly_type
    raise NotImplementedError
  end

  def any_times_changed?
    start_time_changed? || end_time_changed?
  end

  private

  def set_period
    return unless any_times_changed?

    self.period = start_time..end_time
  end
end
