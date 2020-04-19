# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "activity"
  #
  class PhysicalActivityModule < TimelineModule
    self.component_name = 'physical_activity'

    timeline_group :sleep, categories: ['sleep']
    timeline_group(:workouts, categories: ['workout'])
    timeline_group :steps, categories: ['steps']

    highchart(:physical_activity, groups: [:sleep, :steps, :workouts]) do |scrobble_groups, date_scale|
      {
        series: series_for_groups(scrobble_groups, date_scale),

        chart: {
          height: 175
        },

        plotOptions: {
          column: {
            stacking: 'normal',
            pointWidth: 7,
            pointPlacement: 0.5
          },

          xrange: {
            pointWidth: 10
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
            max: 5,
            labels: { enabled: false },
            title: { text: nil },
            visible: false
          },

          {
            min: 0,
            max: 2_500,
            labels: { enabled: false },
            title: { text: nil },
            visible: false
          }
        ]
      }
    end

    class << self
      def series_for_groups(scrobble_groups, _date_scale)
        [
          sleep_series(scrobble_groups[:sleep]),
          workouts_series(scrobble_groups[:workouts]),
          steps_series(scrobble_groups[:steps])
        ]
      end

      def sleep_series(scrobbles)
        { name: 'Sleep', type: 'xrange', data: compiled_sleep_scrobbles(scrobbles) }
      end

      def compiled_sleep_scrobbles(scrobbles)
        scrobbles.each_with_object([]) do |scrobble, collection|
          if merge_sleep_scrobble?(collection.last, scrobble)
            collection.last[:x2] = time_to_js(scrobble.end_time)
          else
            collection << data_for_sleep_scrobble(scrobble)
          end
        end
      end

      def merge_sleep_scrobble?(previous_datapoint, next_scrobble)
        return false if previous_datapoint.blank?

        previous_datapoint[:x2] == time_to_js(next_scrobble.start_time) &&
          previous_datapoint[:depth] == next_scrobble.data['depth']
      end

      def data_for_sleep_scrobble(scrobble)
        {
          x: time_to_js(scrobble.start_time),
          x2: time_to_js(scrobble.end_time),
          y: 2,

          # name: scrobble.data['depth'].to_s.titleize,
          color: color_for_depth(scrobble.data['depth']),
          depth: scrobble.data['depth']
        }
      end

      def workouts_series(scrobbles)
        { name: 'Workout', type: 'xrange', data: compiled_workout_scrobbles(scrobbles) }
      end

      def compiled_workout_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.start_time),
            x2: time_to_js(scrobble.end_time),
            y: 4,

            # name: scrobble.data['type'].to_s.titleize,
            color: '#FFCE7A'
          }
        end
      end

      def steps_series(scrobbles)
        {
          name: 'Steps',
          color: '#E0D99A',

          yAxis: 1,
          type: 'column',
          stacking: nil,

          data: compiled_steps_scrobbles(scrobbles)
        }
      end

      def compiled_steps_scrobbles(scrobbles)
        pairs_for_steps_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_steps_scrobbles(scrobbles)
        scrobbles.group_by { |scrobble| Util.time_floor(scrobble.start_time, 15.minutes) }
          .map do |timestamp, group|
            { x: time_to_js(timestamp), y: group.sum { |scrobble| scrobble.data['count'] } }
          end
      end

      def color_for_depth(depth)
        case depth
        when 'deep' then '#623B80'
        when 'rem' then '#8221CC'
        when 'light' then '#C375FF'
        when 'awake' then '#DDDDDD'
        else '#BB9EFF'
        end
      end
    end
  end
end
