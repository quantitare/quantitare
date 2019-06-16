# frozen_string_literal: true

##
# Shared logic for models that point to a category with some metadata.
#
# 1. Set a constant called +CATEGORY_KLASS+. This class must respond to +.get+ and +.default+.
# 2. Optionally, use the +category_attribute+ macro to set the name of the attribute with which you wish to use to
#    lookup category data.
#
#   class Thing
#     include Categorizable
#
#     CATEGORY_KLASS = ThingCategory
#
#     category_attribute :my_custom_category_name
#   end
#
# == Category classes
#
# A category class must implement the +.get+ method, which takes a string and returns an object that implements the
# following methods:
#
# - +name+: This should be identical to the string used to retrieve via the +get+ method mentioned above.
# - +icon+: This should return an {Icon} object that can be used to display an icon on the page.
#
module Categorizable
  extend ActiveSupport::Concern

  included do
    category_attribute :category
  end

  class_methods do
    def category_klass
      const_get('CATEGORY_KLASS')
    end

    def category_attribute(attr_name = nil)
      cvar_name = '@@_category_attribute'
      attr_name.present? ? class_variable_set(cvar_name, attr_name.to_sym) : class_variable_get(cvar_name)
    end
  end

  def category_klass
    self.class.category_klass
  end

  def category_info
    category_klass.get(send(category_attribute)) || category_klass.default
  end

  def category_name
    category_info.name
  end

  def category_icon
    category_info.icon
  end

  private

  def category_attribute
    self.class.category_attribute
  end
end
