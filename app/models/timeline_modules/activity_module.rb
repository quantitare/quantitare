# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "activity"
  #
  # rubocop:disable Metrics/BlockLength
  class ActivityModule < TimelineModule
    DEVICE_ACTIVITY_CATEGORIES = [
      'Very productive', 'Productive', 'Neutral', 'Unproductive', 'Very unproductive'
    ].freeze

    self.component_name = 'activity'

    timeline_group :device_activity, categories: ['device_activity']

    highchart(:device_activity, groups: [:device_activity]) do |scrobble_groups, date_scale|
      {
        series: chart_series(scrobble_groups, date_scale),

        chart: { height: 175 },

        plotOptions: {
          column: {
            stacking: 'normal',
            pointWidth: 6
          }
        },

        title: { text: nil },
        legend: { enabled: false },
        time: { useUTC: false },

        xAxis: {
          type: 'datetime',
          min: time_to_js(date_scale.beginning_of_scale),
          max: time_to_js(date_scale.end_of_scale)
        },

        yAxis: [
          {
            min: 0,
            max: 15,
            labels: { enabled: false },
            title: { text: nil },
            visible: false
          }
        ]
      }
    end

    summaries(
      :device_activity,
      groups: [:device_activity],
      components: DEVICE_ACTIVITY_CATEGORIES
    ) do |scrobble_groups, _date_scale|
      result = DEVICE_ACTIVITY_CATEGORIES.index_with { |category| Scrobble::Total.new(0, 'min', category) }

      scrobble_groups[:device_activity].each do |scrobble|
        category = category_grouping_for_device_activity_scrobble(scrobble)

        result[category].total += scrobble.data['seconds_spent'].to_f / 60
        result[category].total = result[category].total.round(1)
      end

      result
    end

    class << self
      def category_grouping_for_device_activity_scrobble(scrobble)
        case scrobble.data['rating']
        when 0...15 then 'Very unproductive'
        when 15...40 then 'Unproductive'
        when 40...60 then 'Neutral'
        when 60...85 then 'Productive'
        when 85..100 then 'Very productive'
        else 'Neutral'
        end
      end

      def color_for_key(key)
        case key
        when 'Very unproductive' then '#91D17D'
        when 'Unproductive' then '#BFEBB2'
        when 'Productive' then '#BFDCFF'
        when 'Very productive' then '#75B7FF'
        else '#EEEEEE'
        end
      end

      def compiled_device_activity_scrobbles(scrobbles)
        pairs_for_device_activity_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_device_activity_scrobbles(scrobbles)
        scrobbles.group_by { |scrobble| Util.time_floor(scrobble.start_time, 15.minutes) }
          .map do |timestamp, group|
            {
              x: time_to_js(timestamp),
              y: group.sum { |scrobble| scrobble.data['seconds_spent'].to_f / 60 }.round(1)
            }
          end
      end

      def chart_series(scrobble_groups, date_scale)
        scrobble_groups(scrobble_groups[:device_activity], date_scale).sort_by do |data|
          DEVICE_ACTIVITY_CATEGORIES.index(data[:name])
        end
      end

      def scrobble_groups(scrobbles, _date_scale)
        scrobbles
          .group_by { |scrobble| category_grouping_for_device_activity_scrobble(scrobble) }
          .map do |key, group|
            {
              name: key,
              color: color_for_key(key),

              type: 'column',
              stack: 'device_activity',
              stacking: 'normal',

              data: compiled_device_activity_scrobbles(group)
            }
          end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
