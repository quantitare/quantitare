# frozen_string_literal: true

##
# Ports the +ActiveRecord::Store+ functionality, such as +.store_accessor+, to any module.
#
module Storable
  extend ActiveSupport::Concern

  class_methods do
    def store_reader(store_attribute, *keys)
      keys = keys.flatten

      keys.each do |key|
        define_method(key) do
          send(store_attribute).with_indifferent_access[key]
        end
      end
    end

    def store_writer(store_attribute, *keys)
      keys.each do |key|
        define_method("#{key}=") do |value|
          store = send(store_attribute)
          normalized_key = store.key?(key.to_s) ? key.to_s : key.to_sym
          store[normalized_key] = value
        end
      end
    end

    def store_accessor(store_attribute, *keys)
      store_reader store_attribute, *keys
      store_writer store_attribute, *keys
    end
  end
end
