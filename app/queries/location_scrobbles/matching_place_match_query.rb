# frozen_string_literal: true

module LocationScrobbles
  ##
  # A query that matches location scrobbles against the provided place match's specified source fields.
  #
  class MatchingPlaceMatchQuery < ApplicationQuery
    include PolymorphicJoinable

    relation PlaceScrobble
    params :place_match

    def call
      @relation = relation
        .joins(joins)
        .where(source_match_pairs)
        .where(place_match_pairs)

      relation
    end

    private

    def joins
      polymorphic_joins(place_match.source)
    end

    def place_match_pairs
      place_match.source_fields
    end

    def source_match_pairs
      place_match.source.source_match_condition
    end
  end
end
