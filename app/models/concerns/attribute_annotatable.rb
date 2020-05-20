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
    def jsonb_accessor(attribute_name, **config)
      config.each do |name, type|
        _type, options = Array(type)

        attribute_annotations[attribute_name.to_sym][name.to_sym] = options.try(:delete, :display)
      end

      super
    end

    def attribute_annotations
      @attribute_annotations ||= Hash.new { |h, k| h[k] = {} }
    end

    def jsonb_accessor_names(column)
      attribute_annotations[column].keys.map(&:to_sym)
    end

    def type_for_annotated_attribute(attribute_name)
      info = type_for_attribute(attribute_name)

      info.is_a?(ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Array) ? :array : info.type
    end

    def subtype_for_annotated_attribute(attribute_name)
      type_for_attribute(attribute_name).try(:subtype)&.type
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
