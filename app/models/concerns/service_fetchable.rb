# frozen_string_literal: true

##
# Shared logic for a class that can fetch and cache resources from a web API.
#
module ServiceFetchable
  extend ActiveSupport::Concern

  FETCHER_KLASS = ServiceCache::Fetcher

  class_methods do
    def fetchers
      @fetchers ||= []
    end

    def fetcher(fetcher_name, fetcher_keywords)
      fetchers << fetcher_klass.new(fetcher_name, fetcher_keywords)
    end

    def fetch(opts = {})
      fetchers.each do |fetcher|
        next unless fetcher.can_fetch?(opts)

        return fetcher.fetch(self, opts)
      end

      nil
    end

    def adapter_method
      underscore = name.split('::').last.underscore

      "fetch_#{underscore}"
    end

    private

    def fetcher_klass
      const_defined?('FETCHER_KLASS') ? const_get('FETCHER_KLASS') : FETCHER_KLASS
    end
  end

  def expired?
    expires_at.present? && expires_at < Time.current
  end
end
