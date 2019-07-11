# frozen_string_literal: true

class WithingsAdapter
  ##
  # Compiles a list of {WithingsAdapter::Request}s from a list of categories
  #
  class RequestCompiler
    extend Enumerable

    delegate :map, :count, :length, :first, :last, :[], to: :items

    attr_reader :start_time, :end_time

    def initialize(start_time, end_time)
      @start_time = start_time
      @end_time = end_time
    end

    def each
      return enum_for(:each) unless block_given?

      items.each { |request| yield(request) }
    end

    def items
      requests.values.flatten
    end

    def requests
      @requests ||= {}
    end

    def <<(category)
      configs = CATEGORY_CONFIGS[category]
      return if configs.blank?

      configs.each { |config| add_config(config, category) }
    end

    private

    def add_config(config, category)
      request = prepare_request(config, category)

      requests[request.endpoint] ||= []
      existing_request = requests[request.endpoint].pop
      requests[request.endpoint] += existing_request ? existing_request.merge_or_split(request) : [request]
    end

    def prepare_request(config, category)
      request = WithingsAdapter::Request.new(category, config[:path], config[:params])
      request.set_timestamps(start_time, end_time)

      request
    end
  end
end
