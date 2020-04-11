# frozen_string_literal: true

module TimelineModules
  ##
  # A module that displays the "activity"
  #
  class ActivityModule < TimelineModule
    self.component_name = 'activity'

    timeline_group(:device_activity, categories: ['device_activity']) do |scrobbles|
      scrobbles.group_by { |scrobble| category_grouping_for_device_activity_scrobble(scrobble) }
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
    end
  end
end
