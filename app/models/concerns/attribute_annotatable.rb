# frozen_string_literal: true

##
# Provides annotations for JSONB attributes
#
module AttributeAnnotatable
  extend ActiveSupport::Concern

  included do
    delegate :attribute_annotations, :type_for_annotated_attribute, :subtype_for_annotated_attribute, to: :class
  end

  class_methods do
    def attr_json(attribute_name, type, **options)
      column_name = options[:container_attribute] || attr_json_config.default_container_attribute

      attribute_annotations[column_name.to_sym][attribute_name.to_sym] = options.try(:delete, :display) || {}

      super(attribute_name, type, **options)
    end

    def attribute_annotations
      @attribute_annotations ||= Hash.new { |h, k| h[k] = {} }
    end

    def store_accessor_names(column)
      attribute_annotations[column].keys.map(&:to_sym)
    end

    def type_for_annotated_attribute(attribute_name)
      info = attr_json_registry[attribute_name.to_sym].type

      info.is_a?(AttrJson::Type::Array) ? :array : info.type
    end

    def subtype_for_annotated_attribute(attribute_name)
      attr_json_registry[attribute_name.to_sym].type.try(:base_type)&.type
    end
  end

  def attribute_annotation_for(column)
    attribute_annotations[column.to_sym].map do |attribute_name, display|
      [
        attribute_name,

        {
          name: attribute_name,
          type: type_for_annotated_attribute(attribute_name),
          subtype: subtype_for_annotated_attribute(attribute_name),
          display: display
        }
      ]
    end.to_h
  end

  alias options_config_for attribute_annotation_for
end
