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
    uniqueness: {
      scope: :source_identifier, message: 'cannot have two place assignments per source'
    }

  serialize :source_fields, HashSerializer

  before_validation :set_source_identifier

  def matching_location_scrobbles
    LocationScrobbles::MatchingPlaceMatchQuery.(place_match: self)
  end

  private

  def set_source_identifier
    self.source_identifier = source.try(:source_identifier) if source_identifier.blank?
  end
end
