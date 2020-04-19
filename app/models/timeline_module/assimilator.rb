# frozen_string_literal: true

require_dependency 'timeline_module'

class TimelineModule
  ##
  # A wrapper for {TimelineModule}s that provides an interface for data retrieval, formatting, and so on.
  #
  class Assimilator
    extend Memoist

    attr_reader :timeline_module, :scale, :date

    delegate :user, :timeline_groups, :timeline_highcharts, :timeline_summaries, to: :timeline_module

    def initialize(timeline_module, scale, date)
      @timeline_module = timeline_module
      @scale = scale
      @date = date
    end

    def date_scale
      @date_scale ||= DateScale.new(date, scale)
    end

    def chart_options(chart_name)
      return {} unless timeline_highcharts

      highchart_spec = timeline_highcharts[chart_name]
      return unless highchart_spec

      highchart_spec.generator.(scrobbles(highchart_spec.groups), date_scale)
    end

    def summaries(summaries_name)
      return {} unless timeline_summaries

      summaries_spec = timeline_summaries[summaries_name]
      return unless summaries_spec

      summaries_spec.generator.(scrobbles(summaries_spec.groups), date_scale)
    end

    def datapoints
      group_names.index_with { |group_name| datapoints_for_group(group_name) }.with_indifferent_access
    end

    def group_names
      timeline_groups.keys
    end

    def datapoints_for_group(group_name)
      timeline_groups[group_name].generator.(scrobbles(group_name))
    end

    def scrobbles(groups)
      groups.index_with { |group| scrobbles_for_group(group) }
    end

    def scrobbles_for_group(group)
      selected_categories = categories(group)

      if selected_categories.include?('location')
        return LocationScrobbles::ForTimelineQuery.(user.location_scrobbles, scale: scale, date: date)
      end

      Scrobbles::ForTimelineQuery.(user.scrobbles, scale: scale, date: date, categories: categories(group))
    end

    memoize :scrobbles_for_group

    def categories(group_name)
      timeline_groups[group_name].categories
    end
  end
end
