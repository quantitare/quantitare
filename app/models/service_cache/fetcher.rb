# frozen_string_literal: true

class ServiceCache
  ##
  # Stores the necessary data for fetching a {ServiceCache} record.
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

      fresh = adapter.public_send(cache_klass.adapter_method, opts)
      result = merge_fresh_and_cached!(fresh, cached)

      result
    end

    private

    def find_cached(cache_klass, service, opts = {})
      relation = cache_klass.where(service: service)

      keywords.each { |keyword| relation = cache_klass.where("data->>'#{keyword}' = ?", opts[keyword]) }

      relation.first
    end

    def merge_fresh_and_cached!(fresh, cached)
      unless cached.present?
        fresh.save!
        return fresh
      end

      attrs = fresh.attributes.with_indifferent_access.slice(:data, :expires_at, :tag_list)
      cached.update!(attrs)

      cached
    end
  end
end
