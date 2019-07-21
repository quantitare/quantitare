# frozen_string_literal: true

module Scrobblers
  ##
  # Pulls data from the Twitter API and creates scrobbles from them
  #
  class TwitterScrobbler < Scrobbler
    CHECK_DEEP = {
      CHECK_DEEP => 4.months,
      CHECK_MEDIUM => 1.month,
      CHECK_SHALLOW => 1.week
    }.freeze

    self.request_cadence = Rails.env.test? ? 0.seconds : 1.second
    self.request_chunk_size = 2.weeks

    requires_provider :twitter
    fetches_in_chunks!

    def adapter
      TwitterAdapter.new(service)
    end

    def fetch_scrobbles(start_time, end_time)
      adapter.fetch_scrobbles(start_time, end_time, cadence: request_cadence)
    end
  end
end
