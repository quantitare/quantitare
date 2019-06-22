# frozen_string_literal: true

module LiquidDroppable
  ##
  # @private
  #
  class Drop < Liquid::Drop
    attr_reader :object

    delegate :to_s, to: :object

    def initialize(object)
      @object = object
    end

    def each
      (public_instance_methods - Drop.public_instance_methods).each do |method_name|
        yield [method_name, __send__(method_name)]
      end
    end

    def as_json
      return {} unless defined?(self.class::METHODS)

      Hash[self.class::METHODS.map { |method_name| [method_name, send(method_name).as_json] }]
    end
  end
end
