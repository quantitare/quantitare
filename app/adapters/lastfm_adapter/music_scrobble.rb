# frozen_string_literal: true

class LastfmAdapter
  ##
  # A wrapper that generates a scrobble from raw scrobble data returned by the Last.fm API.
  #
  class MusicScrobble
    extend Memoist

    attr_reader :raw_scrobble, :adapter

    def initialize(raw_scrobble, adapter:)
      @raw_scrobble = raw_scrobble.with_indifferent_access
      @adapter = adapter
    end

    def to_scrobble
      PointScrobble.new(scrobble_params)
    end

    private

    def scrobble_params
      {
        category: 'music',
        data: data,
        user: adapter.user,
        source: adapter.service,
        timestamp: timestamp
      }
    end

    def data
      {
        track: track.to_json,
        artist: artist.to_json,
        album: album.to_json,

        image: {
          small: image_for(:small),
          medium: image_for(:medium),
          large: image_for(:large),
          original: image_for(:extralarge)
        }
      }
    end

    def track
      Aux::MusicTrack.fetch(
        mbid: raw_scrobble[:mbid], title: raw_scrobble[:name], artist_name: artist.name, adapter: adapter
      )
    end
    memoize :track

    def artist
      Aux::MusicArtist.fetch(
        mbid: raw_scrobble[:artist][:mbid], name: raw_scrobble[:artist][:content], adapter: adapter
      )
    end
    memoize :artist

    def album
      Aux::MusicAlbum.fetch(
        mbid: raw_scrobble[:album][:mbid],
        title: raw_scrobble[:album][:content],
        artist_name: raw_scrobble[:album][:artist] || raw_scrobble[:artist][:content],

        adapter: adapter
      )
    end
    memoize :album

    def image_for(size)
      raw_scrobble[:image].find { |image| image.with_indifferent_access[:size] == size.to_s }
    end

    def timestamp
      Time.at(raw_scrobble[:date][:uts].to_i)
    end
  end
end
