# frozen_string_literal: true

module Scrobblers
  ##
  # Pull data from the Rescuetime API and creates scrobbles from them
  #
  class RescuetimeScrobbler < Scrobbler
    TIME_ZONES = Time.zone.class.all.map(&:name)

    delegate :fetch_scrobbles, to: :adapter

    requires_provider :rescuetime
    fetches_in_chunks!

    configure_options(:options) do
      attribute :time_zone, String,
        display: {
          selection: TIME_ZONES,
          desc: <<~TEXT.squish
            The time zone you have selected in Rescuetime. This will determine how the data retrieved from the service
            is parsed.
          TEXT
        }

      validates :time_zone, presence: true, inclusion: { in: TIME_ZONES }
    end

    def adapter
      RescuetimeAdapter.new(service)
    end

    def fetch_and_format_scrobbles(start_time, end_time)
      previous_time_zone = Time.zone
      Time.zone = options.time_zone

      super
    ensure
      Time.zone = previous_time_zone
    end
  end
end
