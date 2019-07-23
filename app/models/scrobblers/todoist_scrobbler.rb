# frozen_string_literal: true

module Scrobblers
  ##
  # Pulls data from the Todoist API and creates scrobbles from them
  #
  class TodoistScrobbler < Scrobbler
    self.request_cadence = Rails.env.test? ? 0.seconds : 1.second
    self.request_chunk_size = 2.weeks

    requires_provider :todoist
    fetches_in_chunks!

    def adapter
      TodoistAdapter.new(service)
    end

    def fetch_scrobbles(start_time, end_time)
      adapter.fetch_scrobbles(start_time, end_time, cadence: request_cadence)
    end
  end
end
