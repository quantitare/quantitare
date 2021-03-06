# frozen_string_literal: true

module Aux
  ##
  # A representation of a music track, shareable across scrobbles.
  #
  class MusicTrack < ServiceCache
    store_accessor :data, :mbid, :title, :artist_name, :duration

    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_track_data_schema.json')

    fetcher :mbid, [:mbid]
    fetcher :title_and_artist_name, [:title, :artist_name]

    def to_music_scrobble_data
      {
        service_identifier: mbid,
        title: title
      }
    end
  end
end
