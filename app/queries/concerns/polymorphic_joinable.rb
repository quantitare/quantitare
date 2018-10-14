# frozen_string_literal: true

##
# Provides helper methods for adding joins on polymorphic associations.
#
module PolymorphicJoinable
  def polymorphic_joins(target)
    target_klass = target.is_a?(Class) ? target : target.class
    table_name = target_klass.table_name
    type = target_klass.name

    <<~SQL.squish
      INNER JOIN "#{table_name}"
        ON "#{_base_table}"."source_id" = "#{table_name}"."id"
        AND "#{_base_table}"."source_type" = '#{type}'
    SQL
  end

  private

  def _base_table
    relation.table_name
  end
end
