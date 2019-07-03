# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class MeasuregrpSample < WithingsAdapter::Sample
    def initialize(category, response_data, config)
      super(category, response_data['date'], response_data, config)
    end

    def to_scrobble
      data.map do |datum|
        ::Scrobble.new(timestamp: timestamp, category: category, data: datum)
      end
    end

    def data
      response_data['measures']
        .select { |measure| measure['type'] == config[:type] }
        .map { |measure| { config[:key] => value_for_measure(measure) } }
    end

    private

    def value_for_measure(measure)
      measure['value'].to_f * 10**measure['unit']
    end
  end
end
