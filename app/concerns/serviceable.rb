# frozen_string_literal: true

##
# Abstractions for the "service object" pattern. The public interface for service objects tend to just have one method,
# which is usually +#call+. This module provides some useful tools to reduce boilerplate and keep the class itself
# clean and readable. A service object, in this sense, is something that carries out one or more "steps," each of which
# will not execute unless its predecessors were successful. Call the +.transactional!+ macro to wrap the process in
# a database transaction, which will roll back if any step fails, even if they don't explicily throw an error. +#call+
# will always return a {Serviceable::Result} object, which will contain any errors that occurred during the process, and
# can be interrogated for whether or not the process was successful. See below for an example of this.
#
#   class DoSomeStuff
#     include Serviceable
#
#     attr_reader :item_1, :item_2
#
#     transactional!
#
#     def initialize(item_1, item_2)
#       @item_1 = item_1
#       @item_2 = item_2
#     end
#
#     def call
#       step :do_one_thing
#       step :do_another_thing
#
#       result.set(item_1: item_1, item_2: item_2)
#     end
#
#     private
#
#     def do_one_thing
#       result.errors << "Couldn't save item_1" unless item_1.save
#     end
#
#     def do_another_thing
#       if item_2.cool?
#         item_2.do_cool_stuff
#       else
#         result.errors << "item_2 isn't cool enough"
#       end
#     end
#   end
#
# Serviceable includes Callable, which passes invocations of +.call+ on the class to an instance, passing its arguments
# into +#initialize+. +#call+ (and, by extension, +.call+) will return a +Serviceable::Result+ object.
#
#   result = DoSomeStuff.(my_item_1, my_item_2)
#
# If all the steps completed successfully, +Serviceable::Result#success?+ will return +true+.
#
#   result.success? # => true
#
# If any errors, occurred, we'll get +false+ from +#success?+, and can see what happened.
#
#   result.success? # => false
#   result.errors   # => ['This thing went wrong', 'That thing wasn't valid']
#
module Serviceable
  extend ActiveSupport::Concern

  included do
    include Callable
    prepend PrependedMethods

    @transactional = false
  end

  class_methods do
    attr_reader :transactional

    def transactional!
      @transactional = true
    end

    def transactional?
      transactional
    end
  end

  # These will get called instead of those defined in the including class.
  module PrependedMethods
    def call(*args)
      if transactional?
        ApplicationRecord.transaction do
          super

          raise ActiveRecord::Rollback unless result.ok?
        end
      else
        super
      end

      result
    end
  end

  def result
    @result ||= Serviceable::Result.new
  end

  private

  def step(method_name)
    result.ok? ? send(method_name) : fail_step
  end

  def fail_step
    transactional? ? raise(ActiveRecord::Rollback) : nil
  end

  def transactional?
    self.class.transactional?
  end
end
