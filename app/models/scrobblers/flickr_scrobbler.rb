# frozen_string_literal: true

module Scrobblers
  ##
  # Pulls data from the Twitter API and creates scrobbles from them
  #
  class FlickrScrobbler < Scrobbler
    CHECK_DEPTHS = {
      CHECK_DEEP => 4.months,
      CHECK_MEDIUM => 1.month,
      CHECK_SHALLOW => 1.week
    }.freeze

    self.request_cadence = Rails.env.test? ? 0.seconds : 0.25.seconds
    self.request_chunk_size = 2.weeks

    requires_provider :flickr
    fetches_in_chunks!

    delegate :fetch_scrobbles, to: :adapter

    def adapter
      FlickrAdapter.new(service, cadence: request_cadence)
    end
  end
end
