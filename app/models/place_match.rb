# frozen_string_literal: true

##
# Stores data for "place matches" which allows us to match apply {Place} changes to {LocationScrobble}s with similar
# characteristics.
#
class PlaceMatch < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :place

  validates :source_field_latitude, presence: true, if: ->(record) { record.source_field_radius.present? }
  validates :source_field_longitude, presence: true, if: ->(record) { record.source_field_radius.present? }

  before_validation :set_source_identifier

  reverse_geocoded_by :source_field_latitude, :source_field_longitude

  def specificity
    specificity_for_name + specificity_for_coordinates
  end

  def matching_location_scrobbles(query = LocationScrobbles::MatchingPlaceMatchQuery)
    query.(place_match: self)
  end

  def source_field_radius=(value)
    super
    return if value.to_bool

    self.source_field_latitude = nil
    self.source_field_longitude = nil
  end

  private

  def set_source_identifier
    self.source_identifier = source.try(:source_identifier) if source_identifier.blank?
  end

  def specificity_for_name
    source_field_name.present? ? 1 : 0
  end

  def specificity_for_coordinates
    source_field_radius.present? ? 1.0 / source_field_radius : 0
  end
end
