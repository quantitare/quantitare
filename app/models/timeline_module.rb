# frozen_string_literal: true

##
# Abstract superclass for objects that gather and format timeline module data.
#
class TimelineModule < ApplicationRecord
  include HasGuid
  include Typeable

  TimelineGroup = Struct.new(:name, :categories)
  TimelineMapbox = Struct.new(:name)
  TimelineHighchart = Struct.new(:name, :groups, :generator)
  TimelineSummaries = Struct.new(:name, :groups, :components, :generator)

  class_attribute :timeline_groups, instance_predicate: false
  class_attribute :timeline_mapboxes, instance_predicate: false
  class_attribute :timeline_highcharts, instance_predicate: false
  class_attribute :timeline_summaries, instance_predicate: false
  class_attribute :component_name

  belongs_to :user

  validates :section, presence: true
  validates :type, presence: true

  load_types_in 'TimelineModules'

  class << self
    def timeline_group(name, categories: [])
      self.timeline_groups ||= {}.with_indifferent_access

      timeline_groups[name] = TimelineGroup.new(name, categories)
    end

    def highchart(name, groups: [], &generator)
      self.timeline_highcharts ||= {}.with_indifferent_access

      timeline_highcharts[name] = TimelineHighchart.new(name, groups, generator)
    end

    def mapbox(name)
      self.timeline_mapboxes ||= {}.with_indifferent_access

      timeline_mapboxes[name] = TimelineMapbox.new(name)
    end

    def summaries(name, groups: [], components: [], &generator)
      self.timeline_summaries ||= {}.with_indifferent_access

      timeline_summaries[name] = TimelineSummaries.new(name, groups, components, generator)
    end

    private

    def time_to_js(time)
      (time.to_f * 1000).to_i
    end
  end

  def to_h
    {
      id: id,
      component: component_name,
      rank: rank
    }
  end
end
