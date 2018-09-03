# frozen_string_literal: true

module Aux
  ##
  # A representation of a music track, shareable across scrobbles.
  #
  class MusicTrack < ServiceCache
    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_track_data_schema.json')

    fetcher :mbid, [:mbid]
    fetcher :title_and_artist_name, [:title, :artist_name]

    def mbid
      data[:mbid]
    end

    def title
      data[:title]
    end

    def artist_name
      data[:artist_name]
    end
  end
end
