# frozen_string_literal: true

module Scrobblers
  ##
  # Pull data from the Trakt.tv API and creates scrobbles from them
  #
  class TraktScrobbler < Scrobbler
    CATEGORIES = %w[movie tv].freeze

    self.request_cadence = Rails.env.test? ? 0.seconds : 0.25.seconds

    requires_provider :trakt
    # requires_metadata_provider(
    #   trakt: ->(scrobbler) { TraktAdapter.new(scrobbler.metadata_service) }
    # )

    configure_options(:options) do
      attribute :categories, Array[String], default: proc { CATEGORIES.dup }, display: { selection: CATEGORIES }

      validate do |object|
        errors[:categories] << 'must contain valid categories' if object.categories.any? { |cat| !cat.in?(CATEGORIES) }
      end
    end

    delegate :categories, to: :options

    def adapter
      TraktAdapter.new(service)
    end
  end
end
