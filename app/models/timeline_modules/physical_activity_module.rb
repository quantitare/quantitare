# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "activity"
  #
  class PhysicalActivityModule < TimelineModule
    self.component_name = 'physical-activity'

    timeline_group(:sleep, categories: ['sleep']) do |scrobbles|
      [{ name: 'Sleep', type: 'xrange', data: compiled_sleep_scrobbles(scrobbles) }]
    end

    timeline_group(:workouts, categories: ['workout']) do |scrobbles|
      [{ name: 'Workout', type: 'xrange', data: compiled_workout_scrobbles(scrobbles) }]
    end

    timeline_group(:steps, categories: ['steps']) do |scrobbles|
      [{
        name: 'Steps',
        color: '#E0D99A',

        yAxis: 1,
        type: 'column',
        stacking: nil,

        data: compiled_steps_scrobbles(scrobbles)
      }]
    end

    class << self
      def compiled_sleep_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.start_time),
            x2: time_to_js(scrobble.end_time),
            y: 2,

            name: scrobble.data['depth'].to_s.titleize,
            color: '#BB9EFF'
          }
        end
      end

      def compiled_workout_scrobbles(scrobbles)
        scrobbles.map do |scrobble|
          {
            x: time_to_js(scrobble.start_time),
            x2: time_to_js(scrobble.end_time),
            y: 4,

            name: scrobble.data['type'].to_s.titleize,
            color: '#FFCE7A'
          }
        end
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
    end
  end
end
