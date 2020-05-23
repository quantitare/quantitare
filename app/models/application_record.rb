# frozen_string_literal: true

##
# Abstract application record
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def json_schema(attribute, path)
      schema_const_name = "#{attribute.upcase}_JSON_SCHEMA"
      const_set(schema_const_name, path)

      validates attribute, json_schema: { schema: const_get(schema_const_name) }
    end
  end
end
