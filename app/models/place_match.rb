# frozen_string_literal: true

##
# Stores data for "place matches" which allows us to match apply {Place} changes to {LocationScrobble}s with similar
# characteristics.
#
class PlaceMatch < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :place

  validates :source_fields,
    presence: true,
    uniqueness: {
      scope: [:user_id, :source_identifier], message: 'cannot have two place assignments per source'
    }
  validate :coordinates_must_be_specified_in_source_field

  serialize :source_fields, HashSerializer

  before_validation :set_source_identifier

  def specificity
    source_fields.keys.length
  end

  def matching_location_scrobbles(query = LocationScrobbles::MatchingPlaceMatchQuery)
    query.(place_match: self)
  end

  private

  def coordinates_must_be_specified_in_source_field
    return if source_fields[:longitude].present? && source_fields[:latitude].present?

    errors[:source_fields] << 'must include coordinates'
  end

  def set_source_identifier
    self.source_identifier = source.try(:source_identifier) if source_identifier.blank?
  end
end
