# frozen_string_literal: true

##
# Enables templating functionality using Liquid. Provides a convenient interface for adding and removing attributes
# from the current template scope.
#
#   templatable.options = { name: 'the {{ thing }}', location: 'somewhere near {{ place }}' }
#   templatable.template_with({ thing: 'frog', place: 'the pond' }) do
#     "#{templatable.templated['name']} lives #{templatable.templated['location']}"
#   end
#   # => 'the frog lives somewhere near the pond'
#
module Templatable
  extend ActiveSupport::Concern

  included do
    class_attribute :template_output_generator
    self.template_output_generator = -> { options.to_h }
  end

  # @return [Liquid::Context] the current context stack for interpolating liquid escape values
  def template_context
    @template_context ||= Liquid::Context.new
  end

  # Alters the current templating scope by adding the given object to it. All of the given object's properties (or at
  # least those made available to its +Liquid::Drop+ object) can be accessed by liquid templates. Works in conjunction
  # with {LiquidDroppable}. This scope alteration will be available through the runtime of the given block.
  #
  #   template_with({ subject: 'world' }) { template_object 'hello, {{ subject }}' } # => 'hello, world'
  #
  # @param object [nil, #to_liquid] the object that you wish to add to the current templating scope. Must respond to
  #   #to_liquid and return a +Liquid::Drop+-like object to properly be added to the scope. If this is the case, its
  #   properties will be made available to any liquid templates.
  def template_with(object = nil)
    if object.nil?
      yield
    elsif !object.respond_to?(:to_liquid)
      Rails.logger.warn("#{object} could not be interpolated with Liquid")
      yield
    else
      object = object.respond_to?(:with_indifferent_access) ? object.with_indifferent_access : object

      begin
        template_context.environments.unshift(object.to_liquid)
        yield
      ensure
        template_context.environments.shift
      end
    end
  end

  # Takes the current template context and generates an interpolated value based on that context.
  #
  # @param object [Object] the string, collection, or hash into which you wish to interpolate the current context
  # @return [Object] the string, collection, or hash filled in with the interpolated values from the current context
  def template_object(object)
    case object
    when String
      template_string(object)
    when Hash
      object.each_with_object({}.with_indifferent_access) { |(key, value), memo| memo[key] = template_object(value) }
    when Enumerable
      object.map { |value| template_object(value) }
    else
      object
    end
  end

  def template_string(string)
    Liquid::Template.parse(string).render!(template_context)
  end

  # @return [#[]] a hash-like object containing the templated values generated from the +template_output_generator+.
  def templated(root_object = nil)
    template_with(root_object) { template_object(instance_exec(&template_output_generator)) }
  end
end
