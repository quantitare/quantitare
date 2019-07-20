# frozen_string_literal: true

class TraktAdapter
  ##
  # @private
  #
  class TVScrobble
    attr_reader :raw_scrobble

    def initialize(raw_scrobble)
      @raw_scrobble = raw_scrobble
    end

    # rubocop:disable Metrics/AbcSize
    def to_scrobble
      ::Scrobble.new(
        category: 'tv',
        timestamp: Time.zone.parse(raw_scrobble['watched_at']),

        data: {
          service_source: 'trakt',

          episode_title: raw_episode['title'],
          episode_identifier: raw_episode['ids']['trakt'].to_s,

          show_title: raw_show['title'],
          show_identifier: raw_show['ids']['trakt'].to_s,
          show_year: raw_show['year'].to_i,

          season_number: raw_episode['season'].to_i,
          episode_number: raw_episode['number'].to_i
        }
      )
    end
    # rubocop:enable Metrics/AbcSize

    def raw_episode
      raw_scrobble['episode']
    end

    def raw_show
      raw_scrobble['show']
    end
  end
end
