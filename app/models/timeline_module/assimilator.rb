# frozen_string_literal: true

require_dependency 'timeline_module'

class TimelineModule
  ##
  # A wrapper for {TimelineModule}s that provides an interface for data retrieval, formatting, and so on.
  #
  class Assimilator
    attr_reader :timeline_module, :scale, :date

    delegate :user, :timeline_groups, to: :timeline_module

    def initialize(timeline_module, scale, date)
      @timeline_module = timeline_module
      @scale = scale
      @date = date
    end

    def datapoints
      group_names.index_with { |group_name| datapoints_for_group(group_name) }
    end

    def group_names
      timeline_groups.keys
    end

    def datapoints_for_group(group_name)
      timeline_groups[group_name].generator.(scrobbles(group_name))
    end

    def scrobbles(group_name)
      Scrobbles::ForTimelineQuery.(user.scrobbles, scale: scale, date: date, categories: categories(group_name))
    end

    def categories(group_name)
      timeline_groups[group_name].categories
    end
  end
end
