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
    uniqueness: { scope: [:user_id, :source_identifier], message: 'cannot have two place assignments per source' }

  json_schema :source_fields, Rails.root.join('app', 'models', 'json_schemas', 'place_match_source_fields_schema.json')

  serialize :source_fields, HashSerializer

  before_validation :set_source_identifier

  attr_accessor :enabled, :to_delete

  def enabled?
    enabled.to_bool
  end

  def to_delete?
    to_delete.to_bool
  end

  def specificity
    source_fields.keys.length
  end

  def matching_location_scrobbles(query = LocationScrobbles::MatchingPlaceMatchQuery)
    query.(place_match: self)
  end

  private

  def set_source_identifier
    self.source_identifier = source.try(:source_identifier) if source_identifier.blank?
  end
end
