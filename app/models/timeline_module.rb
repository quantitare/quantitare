# frozen_string_literal: true

##
# Abstract superclass for objects that gather and format timeline module data.
#
class TimelineModule < ApplicationRecord
  include HasGuid
  include Optionable
  include Typeable

  TimelineGroup = Struct.new(:name, :categories, :generator)

  class_attribute :timeline_groups, instance_predicate: false
  class_attribute :component_name

  belongs_to :user

  validates :section, presence: true
  validates :type, presence: true

  load_types_in 'TimelineModules'
  options_attribute :options

  class << self
    def timeline_group(name, categories: [], &generator)
      self.timeline_groups ||= {}.with_indifferent_access

      timeline_groups[name] = TimelineGroup.new(name, categories, generator)
    end

    private

    def time_to_js(time)
      (time.to_f * 1000).to_i
    end
  end

  def to_h
    {
      id: id,
      component: component_name
    }
  end
end
