# frozen_string_literal: true

class TraktAdapter
  ##
  # @private
  #
  class MovieScrobble
    attr_reader :raw_scrobble

    def initialize(raw_scrobble)
      @raw_scrobble = raw_scrobble
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'movie',
        timestamp: Time.zone.parse(raw_scrobble['watched_at']),

        data: {
          service_source: 'trakt',
          service_identifier: raw_movie['ids']['trakt'].to_s,

          title: raw_movie['title'],
          year: raw_movie['year'].to_i
        }
      )
    end

    def raw_movie
      raw_scrobble['movie']
    end
  end
end
