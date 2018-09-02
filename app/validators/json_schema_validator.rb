# frozen_string_literal: true

##
# Validates a model's JSON or JSONB attribute against a JSON schema.
#
class JsonSchemaValidator < ActiveModel::EachValidator
  def initialize(options)
    options.reverse_merge!(message: :invalid_json)
    options.reverse_merge!(schema: nil)

    super
  end

  def validate_each(record, attribute, value)
    return if schema_validator.valid?(value)

    record.errors[attribute] << 'must be valid'
  end

  def schema_validator
    @schema_validator ||= JSONSchemer.schema(schema)
  end

  def schema
    options[:schema]
  end
end
