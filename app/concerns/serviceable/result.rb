# frozen_string_literal: true

module Serviceable
  ##
  # A data object containing the data for a result of a service object.
  #
  class Result
    attr_writer :errors

    def errors
      @errors ||= []
    end

    def set(attrs = {})
      attrs.each { |key, value| set_attribute(key, value) }
    end

    def success?
      errors.blank?
    end

    alias ok? success?

    def failure?
      !success?
    end

    private

    def set_attribute(name, value)
      class_eval { attr_accessor name }
      send("#{name}=", value)
    end
  end
end
