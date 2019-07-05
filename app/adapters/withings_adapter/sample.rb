# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class Sample
    attr_reader :category, :timestamp, :response_data, :config

    def initialize(category, timestamp, response_data, config)
      @category = category
      @timestamp = Time.zone.at(timestamp.to_i)
      @response_data = response_data
      @config = config
    end

    def to_scrobble
      return nil if data.nil?

      ::Scrobble.new(timestamp: timestamp, category: category, data: data)
    end

    def data
      raise NotImplementedError
    end
  end
end
