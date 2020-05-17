# frozen_string_literal: true

module Scrobblers
  ##
  # A dummy scrobbler. Use for testing.
  #
  class DummyScrobbler < Scrobbler
    jsonb_accessor :options,
      title: :string

    def fetch_scrobbles(_start_time, _end_time)
      []
    end
  end
end
