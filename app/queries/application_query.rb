# frozen_string_literal: true

##
# Sets up macros to reduce repetitive boilerplate while building query objects.
#
# Old-n-busted:
#
#   module MyModels
#     class WithCoolThingsQuery
#       class << self
#         def call(*args)
#           new(*args).call
#         end
#       end
#
#       attr_reader :relation, :a_required_value, :a_value_with_a_default
#
#       def initialize(relation, a_required_value:, a_value_with_a_default: 'some default value')
#         @relation = relation
#         @a_required_value = a_required_value
#         @a_value_with_a_default = a_value_with_a_default
#       end
#
#       def call
#         @relation = relation
#           .joins(:things)
#           .where(things: { some_value: a_required_value, some_other_value: a_value_with_a_default })
#
#         @relation
#       end
#     end
#   end
#
# New hotness:
#
#   module MyModels
#     class WithCoolThingsQuery < ApplicationQuery
#       relation MyModel
#       params :a_required_value, a_value_with_a_default: 'some default value'
#
#       def call
#         @relation = relation
#           .joins(:things)
#           .where(things: { some_value: a_required_value, some_other_value: a_value_with_a_default })
#
#         @relation
#       end
#     end
#   end
#
# The params specified with +params+ become keyword arguments. So, to use this query, we just do the following:
#
#   MyModels::WithCoolThingsQuery.(a_required_value: 'my value')
#   MyModels::WithCoolThingsQuery.(a_required_value: 'my value', a_value_with_a_default: 'my other value')
#
# If you don't provide a required value, we'll get an +ArgumentError+:
#
#   MyModels::WithCoolThingsQuery.() # => raises ArgumentError
#
class ApplicationQuery
  include Callable

  attr_reader :relation

  class << self
    def params(*new_required_params, **new_params_with_defaults)
      attr_reader(*new_required_params)
      self.required_params += new_required_params

      attr_reader(*new_params_with_defaults.keys)
      params_with_defaults.merge! new_params_with_defaults
    end

    def relation(input_relation = nil)
      if input_relation.present?
        @relation = input_relation
      else
        @relation
      end
    end

    def required_params
      @required_params ||= [].to_set
    end

    def params_with_defaults
      @params_with_defaults ||= {}.with_indifferent_access
    end
  end

  def initialize(relation = self.class.relation, **params)
    @relation = relation

    populate_params(params)
  end

  private

  def populate_params(params)
    params = params.reverse_merge(params_with_defaults)

    raise ArgumentError unless required_params.all? { |param| params.key?(param) }

    params.each do |key, val|
      instance_variable_set("@#{key}", val)
    end
  end

  def params_with_defaults
    self.class.params_with_defaults
  end

  def required_params
    self.class.required_params
  end
end
