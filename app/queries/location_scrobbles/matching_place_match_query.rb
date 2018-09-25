# frozen_string_literal: true

module LocationScrobbles
  ##
  # A query that matches location scrobbles against the provided place match's specified source fields.
  #
  class MatchingPlaceMatchQuery
    include Callable

    attr_reader :relation, :place_match

    def initialize(relation = PlaceScrobble, place_match:)
      @relation = relation
      @place_match = place_match
    end

    def call
      @relation = relation
        .joins(joins)
        .where(place_match_pairs)
        .where(source_match_pairs)

      relation
    end

    private

    def joins
      table_name = place_match.source.class.table_name
      type = place_match.source.class.name

      <<~SQL.squish
        INNER JOIN #{table_name}
          ON location_scrobbles.source_id = #{table_name}.id
          AND location_scrobbles.source_type = '#{type}'
      SQL
    end

    def place_match_pairs
      place_match.source_fields
    end

    def source_match_pairs
      place_match.source.source_match_condition
    end
  end
end
