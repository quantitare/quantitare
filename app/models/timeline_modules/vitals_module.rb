# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "vitals"
  #
  class VitalsModule < TimelineModule
    HEART_RATE_INTERVAL = 1.minute

    self.component_name = 'vitals'

    timeline_group :heart_rate, categories: ['heart_rate']

    highchart(:vitals, groups: [:heart_rate]) do |scrobble_groups, date_scale|
      {
        series: heart_rate_series(scrobble_groups[:heart_rate], date_scale),

        chart: {
          height: 175
        },

        plotOptions: {
          column: {
            stacking: 'normal',
            pointWidth: 10,
            pointPlacement: 0.5
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
            max: 150,
            labels: { enabled: false },
            title: { text: nil },
            visible: false
          }
        ]
      }
    end

    class << self
      def heart_rate_series(scrobbles, _date_scale)
        [{
          name: 'Heart rate',
          color: '#E08479',

          type: 'line',

          data: compiled_heart_rate_scrobbles(scrobbles)
        }]
      end

      def compiled_heart_rate_scrobbles(scrobbles)
        base = base_heart_rate_scrobbles(scrobbles)
        final = []

        base.each_with_index do |data, index|
          final << data

          if base[index + 1] && Time.zone.at(base[index + 1][:x] / 1_000) - Time.zone.at(data[:x] / 1_000) > 10.minutes
            final << { x: data[:x] + 60_000, y: nil }
          end
        end

        final
      end

      def base_heart_rate_scrobbles(scrobbles)
        pairs_for_heart_rate_scrobbles(scrobbles).sort_by { |pair| pair[:x] }
      end

      def pairs_for_heart_rate_scrobbles(scrobbles)
        scrobbles.group_by { |scrobble| Util.time_floor(scrobble.start_time, HEART_RATE_INTERVAL) }
          .map do |timestamp, group|
            { x: time_to_js(timestamp), y: (group.sum { |scrobble| scrobble.data['bpm'] } / group.length) }
          end
      end
    end
  end
end
