# frozen_string_literal: true

##
# Adds a +.call+ class method that passes its arguments to +initialize+ and calls the instance method +#call+. Use for
# DRYing up service/query object boilerplate.
#
# ==Usage
#
#   class MyCoolThing
#     include Callable
#
#     def initialize(something)
#       @something = something
#     end
#
#     def call
#       do_stuff
#     end
#
#     # ...
#   end
#
#   MyCoolThing.('stuff')
#
module Callable
  extend ActiveSupport::Concern

  class_methods do
    def call(*args)
      new(*args).call
    end
  end
end
