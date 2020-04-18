# frozen_string_literal: true

module TimelineModules
  ##
  # Adds a timeline +xseries+ and a map to the timeline.
  #
  class LocationModule < TimelineModule
    self.component_name = 'location'

    timeline_group :location, categories: ['location']

    mapbox :location

    highchart(:location, groups: [:location]) do |scrobble_groups, date_scale|
      {
        series: chart_series(scrobble_groups, date_scale),

        chart: {
          type: 'xrange',
          height: 85
        },

        plotOptions: {
          xrange: {
            pointWidth: 15
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
            labels: { enabled: false },
            title: { text: nil },
            visible: false
          }
        ]
      }
    end

    class << self
      def chart_series(scrobble_groups, _date_scale)
        [{ type: 'xrange', data: compiled_location_scrobbles(scrobble_groups[:location]) }]
      end

      def compiled_location_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.start_time),
            x2: time_to_js(scrobble.end_time),
            y: scrobble.place? ? 2 : 1,

            color: scrobble.category_info.colors['primary'] || '#ccc'
          }
        end
      end
    end
  end
end
