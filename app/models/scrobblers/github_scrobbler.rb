# frozen_string_literal: true

module Scrobblers
  ##
  # Pulls data from the GitHub API and creates scrobbles from them
  #
  class GithubScrobbler < Scrobbler
    self.request_cadence = Rails.env.test? ? 0.seconds : 1.second
    self.request_chunk_size = 2.weeks

    requires_provider :github
    fetches_in_chunks!

    delegate :fetch_scrobbles, to: :adapter

    def adapter
      GithubAdapter.new(service, cadence: request_cadence)
    end
  end
end
