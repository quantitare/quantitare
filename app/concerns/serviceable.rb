# frozen_string_literal: true

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
