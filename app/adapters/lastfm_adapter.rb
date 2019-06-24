# frozen_string_literal: true

##
# API wrapper for the Last.fm service.
#
class LastfmAdapter
  extend Memoist

  attr_reader :service

  delegate :user, to: :service

  def initialize(service)
    @service = service
  end

  def client
    Lastfm.new(service.provider_key, service.provider_secret).tap { |instance| instance.session = service.token }
  end
  memoize :client

  def fetch_scrobbles(start_time, end_time)
    raw_scrobbles = client.user.get_recent_tracks(user: username, from: start_time.to_i, to: end_time.to_i)
    parse_scrobbles(raw_scrobbles)
  end

  def fetch_music_track(opts = {})
    mapped_opts = map_opts_for_track(opts)
    raw_track = client.track.get_info(mapped_opts)
    LastfmAdapter::MusicTrack.new(raw_track, service: service).to_aux
  end

  def fetch_music_artist(opts = {})
    mapped_opts = map_opts_for_artist(opts)
    raw_artist = client.artist.get_info(mapped_opts)
    LastfmAdapter::MusicArtist.new(raw_artist, service: service).to_aux
  end

  def fetch_music_album(opts = {})
    mapped_opts = map_opts_for_album(opts)
    raw_album = client.album.get_info(mapped_opts)
    LastfmAdapter::MusicAlbum.new(raw_album, service: service).to_aux
  end

  private

  def parse_scrobbles(raw_scrobbles)
    raw_scrobbles.map do |raw_scrobble|
      LastfmAdapter::MusicScrobble.new(raw_scrobble.with_indifferent_access, adapter: self).to_scrobble
    end
  end

  def username
    service.uid
  end

  def map_opts_for_track(opts)
    mapped_opts = {}

    mapped_opts[:mbid] = opts[:mbid] if opts[:mbid]
    mapped_opts[:track] = opts[:title] if opts[:title]
    mapped_opts[:artist] = opts[:artist_name] if opts[:artist_name]

    mapped_opts
  end

  def map_opts_for_artist(opts)
    mapped_opts = {}

    mapped_opts[:mbid] = opts[:mbid] if opts[:mbid]
    mapped_opts[:artist] = opts[:name] if opts[:name]

    mapped_opts
  end

  def map_opts_for_album(opts)
    mapped_opts = {}

    mapped_opts[:mbid] = opts[:mbid] if opts[:mbid]
    mapped_opts[:album] = opts[:title] if opts[:title]
    mapped_opts[:artist] = opts[:artist_name] if opts[:artist_name]

    mapped_opts
  end
end
