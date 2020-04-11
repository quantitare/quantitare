# frozen_string_literal: true

##
# Application-specific macros and runtime methods for +LightService::Action+s. Remember that, since
# +LightService::Action+s all use class methods, runtime methods should take the context as an argument.
#
module ApplicationAction
  extend ActiveSupport::Concern

  class KeyNotFoundError < StandardError; end

  included do
    extend LightService::Action
  end

  class_methods do
    # =======------------------------------------=======
    # Macros
    # =======------------------------------------=======

    # If you want the context to have a default value for a given key, use this method:
    #
    # Value is not present in the context:
    #
    #   ctx #=> { color: 'Red' }
    #   merge_default(ctx, :name, 'Fred')
    #
    #   ctx #=> { name: 'Fred', color: 'Red' }
    #
    # Value is present in the context:
    #
    #   ctx #=> { name: 'Tyler', color: 'Red' }
    #   merge_default(ctx, :name, 'Fred')
    #
    #   ctx #=> { name: 'Tyler', color: 'Red' }
    #
    # If you use this for a value, it is not necessary to have the key specified in the action's +expects+ macro, but
    # you should call +promises+ for the variable you are merging here, otherwise this method will throw.
    #
    #   promises :name
    #
    #   executed do |ctx|
    #     merge_default(ctx, :name, 'Default name')
    #   end
    #
    # @param ctx [LightService::Context] the context passed in to this action
    # @param var [#to_sym] the name of the variable you wish to add to the context if it doesn't already exist
    # @param default_val [Object] the
    # @raise [KeyNotFound] if the key is not not found on the context (i.e., we haven't used the +promises+ macro to set
    #   the key on the incoming context)
    def merge_default(ctx, var, default_val)
      ctx.public_send("#{var}=", ctx[var].nil? ? default_val : ctx[var])
    rescue NoMethodError
      raise KeyNotFoundError, "Key :#{var} not found on the context. Please add `promises :#{var}` to this action"
    end
  end
end
