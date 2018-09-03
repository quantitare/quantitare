# frozen_string_literal: true

module Scrobblers
  ##
  # A dummy scrobbler. Use for testing.
  #
  class DummyScrobbler < Scrobbler
    def fetch_scrobbles(start_time, end_time)
    end
  end
end
