# frozen_string_literal: true

module Optionable
  ##
  # @private
  #
  class BaseOptionsKlass
    include Virtus.model
    include ActiveModel::Validations

    class << self
      def config
        attribute_set.map do |attribute|
          attribute.options
            .slice(:name, :display, :required)
            .merge(type: attribute.type.primitive.name.underscore)
            .merge(default: _default_value_for_attribute(attribute))
        end
      end

      def _default_value_for_attribute(attribute)
        default_val = attribute.options[:default]
        return default_val unless default_val.respond_to?(:call)

        default_val.(new, attribute)
      end
    end

    def inspect
      attributes
    end
  end
end
