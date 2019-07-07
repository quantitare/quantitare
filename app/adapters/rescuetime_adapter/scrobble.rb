# frozen_string_literal: true

class RescuetimeAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def from_api(data)
        new(data).to_scrobble
      end
    end

    attr_reader :data

    def initialize(data)
      @data = data.symbolize_keys
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'device_activity',
        start_time: start_time,
        end_time: end_time,
        data: parsed_data
      )
    end

    def start_time
      Time.zone.parse(data[:date])
    end

    def end_time
      start_time + 5.minutes
    end

    def parsed_data
      {
        name: data[:activity],
        device_type: 'computer',
        classification: data[:category],
        seconds_spent: data[:time_spent_seconds].to_i,
        rating: rating
      }
    end

    def rating
      case data[:productivity].to_i
      when -2 then 0
      when -1 then 25
      when 0 then 50
      when 1 then 75
      when 2 then 100
      end
    end
  end
end
