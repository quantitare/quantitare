# frozen_string_literal: true

class ServiceCache < ApplicationRecord
  ##
  # Fetches, caches, and retrieves the necessary data for fetching a {ServiceCache} record.
  #
  class Fetcher
    attr_reader :name, :keywords

    def initialize(name, keywords)
      @name = name
      @keywords = keywords
    end

    def can_fetch?(opts = {})
      opts = opts.with_indifferent_access
      keywords.all? { |keyword| opts.key?(keyword) }
    end

    def fetch(cache_klass, opts = {})
      opts = opts.with_indifferent_access
      adapter = opts[:adapter]

      cached = find_cached(cache_klass, adapter.service, opts)
      return cached if cached.present? && !cached.expired?

      fresh = adapter.public_send(cache_klass.fetch_adapter_method, opts)

      return nil if fresh.blank?

      result = merge_fresh_and_cached!(fresh, cached)

      result
    end

    private

    def find_cached(cache_klass, service, opts = {})
      relation = cache_klass
        .where(service: service)
        .where("#{cache_klass.table_name}.data @> ?::jsonb", keyword_attributes(opts).to_json)

      relation.first
    end

    def merge_fresh_and_cached!(fresh, cached)
      if cached.blank?
        fresh.save!
        return fresh
      end

      attrs = fresh.attributes.with_indifferent_access.slice(*merge_attributes)
      cached.update!(attrs)

      cached
    end

    def merge_attributes
      [:data, :expires_at, :tag_list]
    end

    def keyword_attributes(opts)
      Hash[keywords.map { |keyword| [keyword, opts[keyword]] }]
    end
  end
end
