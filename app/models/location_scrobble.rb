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

  scope :place, -> { where(type: PlaceScrobble.name) }
  scope :transit, -> { where(type: TransitScrobble.name) }

  scope :from_other_sources, ->(other) { where.not(id: other.id).where.not(source: other.source) }

  accepts_nested_attributes_for :place

  reverse_geocoded_by :latitude, :longitude

  alias coordinates to_coordinates

  def place?
    is_a? PlaceScrobble
  end

  def transit?
    is_a? TransitScrobble
  end

  def friendly_type
    raise NotImplementedError
  end

  def duration
    end_time - start_time
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
