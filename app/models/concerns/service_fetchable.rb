# frozen_string_literal: true

##
# Shared logic for a class that can fetch and cache resources from a web API.
#
module ServiceFetchable
  extend ActiveSupport::Concern

  FETCHER_KLASS = ServiceFetchable::Fetcher
  SEARCHER_KLASS = ServiceFetchable::Searcher

  ##
  # Mixed in as class methods
  #
  module ClassMethods
    def fetchers
      @fetchers ||= []
    end

    def searchers
      @searchers ||= []
    end

    def fetcher(fetcher_name, fetcher_keywords)
      fetchers << fetcher_klass.new(fetcher_name, fetcher_keywords)
    end

    def searcher(*searcher_keywords, **searcher_keywords_with_defaults)
      searchers << searcher_klass.new(*searcher_keywords, searcher_keywords_with_defaults)
    end

    def search(opts = {})
      searchers.each do |searcher|
        next unless searcher.can_search?(opts)

        return searcher.search(self, opts)
      end

      []
    end

    def fetch(opts = {})
      fetchers.each do |fetcher|
        next unless fetcher.can_fetch?(opts)

        return fetcher.fetch(self, opts)
      end

      nil
    end

    def fetch_adapter_method
      underscore = name.split('::').last.underscore

      "fetch_#{underscore}"
    end

    def search_adapter_method
      underscore = name.split('::').last.pluralize.underscore

      "search_#{underscore}"
    end

    def search_cache_method
      'cache_search'
    end

    private

    def fetcher_klass
      const_defined?('FETCHER_KLASS') ? const_get('FETCHER_KLASS') : FETCHER_KLASS
    end

    def searcher_klass
      const_defined?('SEARCHER_KLASS') ? const_get('SEARCHER_KLASS') : SEARCHER_KLASS
    end
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end
end
