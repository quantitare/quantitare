# frozen_string_literal: true

##
# DSL for autoloadable STI types. Used for the purposes of validating the `type` column intended for STI, as well as
# keeping STI types organized.
#
#   # app/models/thing.rb
#
#   class Thing < ApplicationRecord
#     include Typeable
#
#     load_types_in 'Things'
#   end
#
#   # app/models/things/widget.rb
#
#   class Widget < Thing
#   end
#
#   # elsewhere...
#
#   Widget.new.valid_type? #=> true
#
#   Thing.new(type: 'Gadget').valid_type? #=> false
#
module Typeable
  extend ActiveSupport::Concern

  included do
    validate :validate_type

    default_scope { where(type: type_names) }
  end

  class_methods do
    def load_types_in(module_name, my_name = module_name.singularize)
      class_variable_set('@@type_module_name', module_name)
      class_variable_set('@@type_base_klass_name', my_name)
      class_variable_set('@@types', fetch_base_types(module_name))
    end

    def types
      class_variable_get('@@types').map(&:constantize)
    end

    def type_names
      class_variable_get('@@types')
    end

    def friendly_name
      name.split('::').last.underscore.titleize
    end

    def inherited(subklass)
      class_variable_get('@@types') << subklass.name unless class_variable_get('@@types').include?(subklass.name)

      super
    end

    private

    def fetch_base_types(module_name)
      base_path = Rails.root.join('app', 'models', module_name.underscore, '*.rb')
      Dir[base_path].map { |path| module_name + '::' + File.basename(path, '.rb').camelize }
    end
  end

  def validate_type
    errors.add(:type, 'cannot be changed after creation') if type_changed? && !new_record?
    errors.add(:type, 'is not valid') unless valid_type?
  end

  def valid_type?
    type.present? && types.include?(type.constantize)
  end

  def types
    self.class.types
  end
end
