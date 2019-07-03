# frozen_string_literal: true

class WithingsAdapter
  ##
  # Parses category configuration and formats requests based on that configuration data
  #
  class Request
    class << self
      def for_categories(categories, start_time, end_time)
        collection = WithingsAdapter::RequestCompiler.new(start_time, end_time)
        categories.each { |category| collection << category }

        collection
      end
    end

    attr_accessor :categories
    attr_reader :path, :params

    def initialize(category, path, params = {})
      @categories = [category]
      @path = path
      @params = params.dup
    end

    def endpoint
      [path, params[:action]]
    end

    def endpoint_config
      ENDPOINT_CONFIGS[endpoint]
    end

    def set_timestamps(start_time, end_time)
      params.merge!(
        key_for_timestamp('startdate') => value_for_timestamp(start_time),
        key_for_timestamp('enddate') => value_for_timestamp(end_time)
      )
    end

    def merge_or_split(other_request)
      if endpoint_config[:multi]
        params[multi_field] = gather_multi_field_from_other_request(other_request)
        self.categories += other_request.categories

        [self]
      else
        [self, other_request]
      end
    end

    def increment_offset!
      params[:offset] ||= 0
      params[:offset] += 1
    end

    def paged?
      endpoint_config[:paged]
    end

    def multi_field
      endpoint_config[:multi_field]
    end

    def multi_field_join
      endpoint_config[:multi_field_join]
    end

    def time_format
      endpoint_config[:time_format]
    end

    def key_for_timestamp(timestamp_name)
      time_format == :ymd ? "#{timestamp_name}ymd".to_sym : timestamp_name
    end

    def value_for_timestamp(timestamp)
      time_format == :ymd ? timestamp.to_date.to_s : timestamp.to_i
    end

    private

    def gather_multi_field_from_other_request(other_request)
      current_multi_field = (params[multi_field] || '').split(multi_field_join)
      current_multi_field += (other_request.params[multi_field] || '').split(multi_field_join)

      current_multi_field.join(multi_field_join)
    end
  end
end
