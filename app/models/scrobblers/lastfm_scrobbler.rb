# frozen_string_literal: true

module Scrobblers
  ##
  # Creates scrobbles for Last.fm scrobbles.
  #
  class LastfmScrobbler < Scrobbler
    requires_provider :lastfm
  end
end
