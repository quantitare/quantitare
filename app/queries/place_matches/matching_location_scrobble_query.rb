# frozen_string_literal: true

module PlaceMatches
  ##
  # This returns a "fuzzy match" of {PlaceMatch}es whose specified +source_fields+ match the given {LocationScrobble}'s
  # attributes. The results need to be narrowed down since query only matches on an +OR+ condition across all of
  # the scrobble's attributes. This may produce matches whose, for example, name might match the scrobble's but whose
  # coordinates might not.
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
        .where(
          where,
          name: location_scrobble.name,
          longitude: location_scrobble.longitude,
          latitude: location_scrobble.latitude
        )

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
        place_matches.source_fields->>'name' = :name
          OR ((place_matches.source_fields->>'longitude')::numeric = :longitude
            AND (place_matches.source_fields->>'latitude')::numeric = :latitude)
      SQL
    end
  end
end
