# frozen_string_literal: true

module PlaceMatches
  ##
  # This returns all {PlaceMatch}es whose specified +source_fields+ match the given {LocationScrobble}'s associated
  # attributes.
  #
  class MatchingLocationScrobbleQuery
    include Callable
    include PolymorphicJoinable

    attr_reader :relation, :location_scrobble

    def initialize(relation = PlaceMatch, location_scrobble:)
      @relation = relation
      @location_scrobble = location_scrobble
    end

    def call
      @relation = relation
        .joins(joins)
        .where(source_match_pairs)
        .where(where, *where_params)

      relation
    end

    private

    def joins
      polymorphic_joins(location_scrobble.source)
    end

    def source_match_pairs
      location_scrobble.source.source_match_condition
    end

    def where
      <<~SQL.squish
        (NOT (place_matches.source_fields ? 'name') OR place_matches.source_fields @> :name::jsonb)
          AND (
            NOT (place_matches.source_fields ?& array['longitude', 'latitude'])
              OR place_matches.source_fields @> :coordinates::jsonb
          )
      SQL
    end

    def where_params
      [
        name: { name: location_scrobble.name }.to_json,
        coordinates: { longitude: location_scrobble.longitude, latitude: location_scrobble.latitude }.to_json
      ]
    end
  end
end