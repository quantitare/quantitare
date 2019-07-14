# frozen_string_literal: true

##
# Provides an interface for configurable options on one or more of a model's attributes. That column ought to be a
# +text+ column, as this serializes a class that serves as a data object, complete with its own DSL for defining
# attributes, validation schema and other cool stuff. Attribute DSL is provided by Virtus, and validations are provided
# by ActiveModel::Validations.
#
#   class Thing
#     include Optionable
#
#     options_attribute :options
#
#     configure_options(:options) do
#       attribute :name, String
#       attribute :description, String, default: 'This is a Thing'
#
#       validates :description, presence: true
#     end
#   end
#
#   my_thing = Thing.new
#   my_thing.options #=> #<Thing::Options @name=nil @description="This is a Thing">
#
#   my_thing.options.valid? #=> true
#
#   my_thing.options.description = ''
#   my_thing.options.valid? #=> false
#   my_thing.valid? #=> false
#   my_thing.errors[:options] => ["must be valid"]
#   my_thing.options.errors[:quantity] => ["can't be blank"]
#
# This is designed to work in conjunction with, for example, a model that might have STI types (it works great with
# +Typeable+!) that might have some auxiliary data that we don't necessarily want to create columns for. It's worth
# noting that since options created by this module aren't indexable, so keep that in mind when designing your table.
#
# == Mass Assignment
#
# +Optionable+ is compatible with mass assignment, albeit with slightly different behavior. Say we're using +Thing+ from
# the above example. We can mass-assign +options+ using a key called +options+:
#
#   Thing.new({ foo: 'bar', options: { name: 'A cool name', description: 'A cool description' } })
#
module Optionable
  extend ActiveSupport::Concern

  included do
    validate :options_must_be_valid
    class_attribute :options_attributes, default: {}.with_indifferent_access
  end

  # rubocop:disable Metrics/BlockLength
  class_methods do
    def inherited(subklass)
      super

      options_attributes.each do |attribute_name, opts|
        next if opts[:type].present?

        new_klass = new_options_klass

        subklass.const_set(options_klass_name_for(attribute_name), new_klass)
        subklass.public_send("#{attribute_name}_type=", new_klass)
      end
    end

    def options_attribute(attribute_name, opts = {})
      options_attributes[attribute_name] = opts.with_indifferent_access
      class_attribute "#{attribute_name}_type".to_sym
      serialize attribute_name, options_klass_for(attribute_name)
      after_initialize -> { initialize_options_for(attribute_name) }

      define_methods_for_options_attribute(attribute_name)
    end

    def configure_options(options_attribute, &blk)
      unless options_attributes.key?(options_attribute)
        raise ArgumentError, "Cannot configure unknown options attribute #{options_attribute.inspect}"
      end

      options_klass_for(options_attribute).instance_eval(&blk)
    end

    def options_klass_for(attribute_name)
      existing_type = options_attributes[attribute_name][:type] || send("#{attribute_name}_type")
      existing_type.presence || options_klass_constant_for(attribute_name)
    end

    private

    def fq_options_klass_name_for(attribute_name)
      "::#{name}::#{options_klass_name_for(attribute_name)}"
    end

    def options_klass_name_for(attribute_name)
      attribute_name.to_s.camelize
    end

    # rubocop:disable Lint/UselessAssignment
    def new_options_klass
      # Setting a local variable here so it doesn't mess up the bracket highlighter in my editor.
      klass = Class.new(Optionable::BaseOptionsKlass)
    end
    # rubocop:enable Lint/UselessAssignment

    def options_klass_constant_for(attribute_name)
      fq_klass_name = fq_options_klass_name_for(attribute_name)
      klass_name = options_klass_name_for(attribute_name)

      const_set(klass_name, new_options_klass) unless const_defined?(fq_klass_name)
      const_get(klass_name)
    end

    def define_methods_for_options_attribute(attribute_name)
      class_eval <<-RUBY, __FILE__, __LINE__ + 1
        class << self
          def #{attribute_name}_type_with_setup=(value)
            value = value.to_s.constantize

            self.#{attribute_name}_type_without_setup = value
            serialize #{attribute_name.inspect}, value
          end

          alias #{attribute_name}_type_without_setup= #{attribute_name}_type=
          alias #{attribute_name}_type= #{attribute_name}_type_with_setup=
        end

        def #{attribute_name}=(value)
          target_klass = options_klass_for('#{attribute_name}')

          if value.is_a?(Hash)
            super(target_klass.new(value))
          else
            super(value)
          end
        end
      RUBY
    end
  end
  # rubocop:enable Metrics/BlockLength

  def initialize_options_for(attribute_name)
    assign_attributes(attribute_name => options_klass_for(attribute_name).new) unless public_send(attribute_name)
  end

  def options_attributes
    self.class.options_attributes
  end

  def options_klass_for(attribute_name)
    send("#{attribute_name}_type") || self.class.options_klass_for(attribute_name)
  end

  def options_config_for(attribute_name)
    options_klass_for(attribute_name).config
  end

  def options_must_be_valid
    options_attributes.each_key do |attribute|
      value = public_send(attribute)
      next if value.blank?

      errors[attribute] << 'must be valid' unless value.valid?
    end
  end
end
