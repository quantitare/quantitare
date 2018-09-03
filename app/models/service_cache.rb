# frozen_string_literal: true

##
# Cached data for a {Service}. Used to prevent repetitive API calls to a given service.
#
class ServiceCache < ApplicationRecord
  EXPIRY_INTERVAL = 1.month.freeze

  serialize :data, HashSerializer

  belongs_to :service, optional: true

  acts_as_taggable

  delegate :user, to: :service

  class << self
    def fetchers
      @fetchers ||= []
    end

    def fetcher(fetcher_name, fetcher_keywords)
      fetchers << ServiceCache::Fetcher.new(fetcher_name, fetcher_keywords)
    end

    def fetch(opts = {})
      fetchers.each do |fetcher|
        next unless fetcher.can_fetch?(opts)

        return fetcher.fetch(self, opts)
      end
    end

    def adapter_method
      underscore = name.split('::').last.underscore

      "fetch_#{underscore}"
    end
  end

  def expired?
    expires_at.present? && expires_at < Time.now
  end
end
