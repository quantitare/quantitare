# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  include HasGuid
  include Periodable
  include Categorizable

  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :source, polymorphic: true

  validates :start_time, presence: true
  validates :end_time, presence: true

  after_validation :compute_coordinates, if: :trackpoints_changed?

  default_scope -> { order(start_time: :asc) }

  def place?
    is_a? PlaceScrobble
  end

  def transit?
    is_a? TransitScrobble
  end

  def friendly_type
    raise NotImplementedError
  end

  private

  def compute_coordinates
    self.longitude = average_longitude
    self.latitude = average_latitude
  end

  def average_longitude
    trackpoint_average(:longitude)
  end

  def average_latitude
    trackpoint_average(:latitude)
  end

  def trackpoint_average(attribute)
    return nil unless trackpoints.length.positive?

    trackpoints.map { |trackpoint| trackpoint.with_indifferent_access[attribute] }.sum / trackpoints.length
  end
end
