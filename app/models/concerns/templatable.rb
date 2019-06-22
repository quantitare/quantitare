# frozen_string_literal: true

##
# Enables templating functionality using Liquid.
#
module Templatable
  extend ActiveSupport::Concern

  def template_context
    @template_context ||= Liquid::Context.new
  end

  def template_with(object = nil)
    if object.nil?
      yield
    elsif !object.respond_to?(:to_liquid)
      Rails.logger.warn("#{object} could not be interpolated with Liquid")
      yield
    else
      context = template_context

      begin
        context.environments.unshift(object.to_liquid)
        yield
      ensure
        context.environments.shift
      end
    end
  end

  def template_object(object)
    case object
    when String
      template_string(object)
    when Hash
      object.each_with_object({}.with_indifferent_access) { |(key, value), memo| memo[key] = template_object(value) }
    when Array
      object.map { |value| interpolate_object(value) }
    else
      object
    end
  end

  def template_string(string)
    Liquid::Template.parse(string).render!(template_context)
  end

  def templated(root_object = nil)
    template_with(root_object) { template_object(options.to_h) }
  end
end
