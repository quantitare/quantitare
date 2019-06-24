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
        service_source: 'lastfm', # TODO: to be changed when data services can be selected

        track: track.to_music_scrobble_data,
        artist: artist.to_music_scrobble_data,
        album: album.to_music_scrobble_data,

        image: {
          small: image_for(:small),
          medium: image_for(:medium) || image_for(:small),
          large: image_for(:large) || image_for(:medium) || image_for(:small),
          original: image_for(:extralarge) || image_for(:large) || image_for(:medium) || image_for(:small)
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
      Time.zone.at(raw_scrobble[:date][:uts].to_i)
    end
  end
end
