# frozen_string_literal: true

module Scrobblers
  ##
  # Returns a list of {Scrobbler}s that have a check scheduled on the given schedule. While there is a more succinct
  # way of writing this query using the PostgreSQL +<@+ operator, a GiN index does not work with that operator. Instead,
  # we use a disjunction of +@>+ operators in order to take advantage of the index existing on the +schedules+ column.
  #
  class ScheduledForQuery < ApplicationQuery
    MAPPING_CONDITION = 'schedules @> :mapping::jsonb'

    relation Scrobbler
    params :schedule

    def call
      original_relation = relation
      mappings = check_schedule_mappings
      first_mapping = mappings.shift

      self.relation = relation.where(MAPPING_CONDITION, mapping: first_mapping.to_json)
      mappings.each do |mapping|
        self.relation = relation.or(original_relation.where(MAPPING_CONDITION, mapping: mapping.to_json))
      end

      relation
    end

    private

    def check_schedule_mappings
      Scrobbler::CHECKS.map { |check| { check => schedule } }
    end
  end
end
