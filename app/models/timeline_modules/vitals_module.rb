# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "vitals"
  #
  class VitalsModule < TimelineModule
    HEART_RATE_INTERVAL = 1.minute

    self.component_name = 'vitals'

    timeline_group(:heart_rate, categories: ['heart_rate']) do |scrobbles|
      [{
        name: 'Heart rate',
        color: '#E08479',

        type: 'line',

        data: compiled_heart_rate_scrobbles(scrobbles)
      }]
    end

    class << self
      def compiled_heart_rate_scrobbles(scrobbles)
        base = base_heart_rate_scrobbles(scrobbles)
        final = []

        base.each_with_index do |data, index|
          final << data

          if base[index + 1] && Time.zone.at(base[index + 1][:x] / 1000) - Time.zone.at(data[:x] / 1000) > 5.minutes
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
