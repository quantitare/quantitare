# frozen_string_literal: true

module PlaceMatches
  ##
  # This returns all {PlaceMatch}es whose specified +source_fields+ match the given {LocationScrobble}'s associated
  # attributes.
  #
  class MatchingLocationScrobbleQuery < ApplicationQuery
    include PolymorphicJoinable

    RADIUS_COLUMN_NAME = :'place_matches.source_field_radius'

    relation PlaceMatch
    params :location_scrobble

    def call
      @relation = relation
        .select(coordinate_query_options[:select])
        .joins(source_joins)
        .where(source_match_pairs)
        .order(coordinate_query_options[:order])

      define_filters!

      relation
    end

    private

    def define_filters!
      @relation = relation
        .where(*coordinate_query_options[:conditions])
        .or(relation.where(source_field_name: location_scrobble.read_attribute(:name)))
    end

    def source_joins
      polymorphic_joins(location_scrobble.source)
    end

    def source_match_pairs
      location_scrobble.source.source_match_condition
    end

    def coordinate_query_options
      latitude, longitude = extract_coordinates

      relation.near_scope_options(latitude, longitude, RADIUS_COLUMN_NAME)
    end

    def extract_coordinates
      Geocoder::Calculations.extract_coordinates(location_scrobble)
    end
  end
end
