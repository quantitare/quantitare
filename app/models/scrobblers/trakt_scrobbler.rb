# frozen_string_literal: true

module Scrobblers
  ##
  # Pull data from the Trakt.tv API and creates scrobbles from them
  #
  class TraktScrobbler < Scrobbler
    CATEGORIES = %w[movie tv].freeze
    CHECK_DEPTHS = {
      CHECK_DEEP => 1.year,
      CHECK_MEDIUM => 1.month,
      CHECK_SHALLOW => 1.week
    }.freeze

    self.request_cadence = Rails.env.test? ? 0.seconds : 0.25.seconds

    jsonb_accessor :options,
      categories: [:string, array: true, default: proc { CATEGORIES.dup }, display: { selection: CATEGORIES }]

    validate do |object|
      errors[:categories] << 'must contain valid categories' if object.categories.any? { |cat| !cat.in?(CATEGORIES) }
    end

    requires_provider :trakt
    # requires_metadata_provider(
    #   trakt: ->(scrobbler) { TraktAdapter.new(scrobbler.metadata_service) }
    # )

    def adapter
      TraktAdapter.new(service)
    end

    def fetch_scrobbles(start_time, end_time)
      adapter.fetch_scrobbles(start_time, end_time, categories: categories, cadence: request_cadence)
    end
  end
end
