# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class SleepSample
    DEPTH_MAP = {
      1 => Categories::Sleep::D_LIGHT,
      2 => Categories::Sleep::D_DEEP,
      3 => Categories::Sleep::D_REM
    }.freeze

    class << self
      def for_series(series, category, config)
        config[:aggregate] ? new(category, series, config) : series.map { |data| new(category, data, config) }
      end
    end

    attr_reader :category, :data, :config

    def initialize(category, data, config)
      @category = category
      @data = data
      @config = config
    end

    def to_scrobble
      return scrobbles_from_aggregate if config[:aggregate] || data.is_a?(Array)
      return scrobbles_from_datapoints if config[:individual_datapoints]

      scrobble_from_root
    end

    private

    def scrobbles_from_aggregate
      scrobbles = []

      data
        .sort_by { |segment| segment['startdate'].to_i }
        .each { |segment| process_aggregate_segment!(segment, scrobbles) }

      scrobbles
    end

    def process_aggregate_segment!(segment, scrobbles)
      previous_scrobble = scrobbles.last
      start_time = Time.zone.at(segment['startdate'].to_i)
      end_time = Time.zone.at(segment['enddate'].to_i)

      if previous_scrobble && previous_scrobble.end_time >= start_time
        previous_scrobble.end_time = end_time
      else
        scrobbles << ::Scrobble.new(category: category, start_time: start_time, end_time: end_time)
      end
    end

    def scrobbles_from_datapoints
      pairs_from_datapoints.map { |timestamp, sample| ::Scrobble.new(params_for_datapoint(timestamp, sample)) }
    end

    def pairs_from_datapoints
      data[config[:datapoint_name]]
    end

    def params_for_datapoint(timestamp, sample)
      {
        category: category,
        timestamp: Time.zone.at(timestamp.to_i),

        data: {
          config[:key] => sample
        }
      }
    end

    def scrobble_from_root
      data['state'].zero? ? [] : ::Scrobble.new(params_for_root)
    end

    def params_for_root
      {
        category: category,

        start_time: Time.zone.at(data['startdate'].to_i),
        end_time: Time.zone.at(data['enddate'].to_i),

        data: {
          depth: DEPTH_MAP[data['state']]
        }
      }
    end
  end
end
