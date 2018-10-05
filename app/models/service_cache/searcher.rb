# frozen_string_literal: true

class ServiceCache < ApplicationRecord
  ##
  # An object that interfaces with an adapter to find and cache multiple {ServiceCache}-style records.
  #
  class Searcher
    attr_reader :keywords, :keywords_with_defaults

    def initialize(keywords, keywords_with_defaults)
      @keywords = keywords
      @keywords_with_defaults = keywords_with_defaults
    end

    def search(cache_klass, opts = {})
      opts = opts.deep_symbolize_keys
      adapter = opts[:adapter]

      results = adapter.public_send(cache_klass.search_adapter_method, opts)

      cache_klass.import(results, on_duplicate_key_ignore: true)
    end
  end
end
