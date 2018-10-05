# frozen_string_literal: true

module ServiceFetchable
  ##
  # An object that interfaces with an adapter to find and cache multiple {ServiceFetchable}-style records.
  #
  class Searcher
    attr_reader :required_keywords, :keywords_with_defaults

    def initialize(*required_keywords, **keywords_with_defaults)
      @required_keywords = required_keywords
      @keywords_with_defaults = keywords_with_defaults
    end

    def can_search?(opts)
      opts = prepare_opts(opts)

      required_keywords.all? { |keyword| opts.key?(keyword) }
    end

    def search(cache_klass, opts = {})
      opts = prepare_opts(opts)
      adapter = opts[:adapter]

      results = adapter.public_send(cache_klass.search_adapter_method, **opts.except(:adapter))

      cache_klass.import(results, on_duplicate_key_ignore: true)

      cache_klass.where(service: adapter.service, service_identifier: results.map(&:service_identifier))
    end

    private

    def prepare_opts(opts)
      opts = opts.deep_symbolize_keys
      opts = opts.reverse_merge(keywords_with_defaults)

      opts
    end
  end
end
