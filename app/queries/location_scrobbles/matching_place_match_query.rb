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

      add_name_condition!
      add_radius_condition!

      relation
    end

    private

    def joins
      polymorphic_joins(place_match.source)
    end

    def source_match_pairs
      place_match.source.source_match_condition
    end

    def add_name_condition!
      return if place_match.source_field_name.blank?

      @relation = relation.where(name: place_match.source_field_name)
    end

    def add_radius_condition!
      return if place_match.source_field_radius.blank?

      @relation = relation.near(place_match, place_match.source_field_radius)
    end
  end
end
