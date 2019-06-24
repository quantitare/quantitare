# frozen_string_literal: true

##
#
#
module Typeable
  extend ActiveSupport::Concern

  included do
    validate :validate_type
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
