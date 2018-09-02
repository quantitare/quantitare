# frozen_string_literal: true

module Scrobblers
  ##
  # Creates scrobbles for Last.fm scrobbles.
  #
  class LastfmScrobbler < Scrobbler
    requires_provider :lastfm

    delegate :fetch_scrobbles, to: :adapter

    def adapter
      @adapter ||= LastfmAdapter.new(service)
    end
  end
end
