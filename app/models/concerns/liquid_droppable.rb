# frozen_string_literal: true

##
# Makes a class interpolatable in a Liquid template
#
module LiquidDroppable
  extend ActiveSupport::Concern

  included do
    const_set :Drop, Class.new(LiquidDroppable::Drop) unless Kernel.const_defined?("#{name}::Drop")
  end

  def to_liquid
    self.class::Drop.new(self)
  end
end
