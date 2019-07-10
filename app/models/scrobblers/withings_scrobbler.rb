# frozen_string_literal: true

module Scrobblers
  ##
  # Pull data from the Withings Healthmate API and creates scrobbles from them
  #
  class WithingsScrobbler < Scrobbler
    CATEGORIES = %w[
      blood_pressure_diastolic blood_pressure_systolic body_temperature active_calorie_burn floors_climbed heart_rate
      respiratory_rate sleep spo2 steps weight workout
    ].freeze

    self.request_cadence = Rails.env.test? ? 0.seconds : 1.5.seconds
    self.request_chunk_size = 24.hours

    requires_provider :withings2
    fetches_in_chunks!

    configure_options(:options) do
      attribute :categories, Array[String], display: { selection: CATEGORIES }

      validate do |object|
        errors[:categories] << 'must contain valid categories' if object.categories.any? { |cat| !cat.in?(CATEGORIES) }
      end
    end

    delegate :categories, to: :options

    def adapter
      WithingsAdapter.new(service)
    end

    def fetch_scrobbles(start_time, end_time)
      adapter.fetch_scrobbles(start_time, end_time, categories: categories, cadence: request_cadence)
    end
  end
end
