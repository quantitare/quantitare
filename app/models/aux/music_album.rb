# frozen_string_literal: true

module Aux
  ##
  # A representation of a music album, shareable across scrobbles.
  #
  class MusicAlbum < ServiceCache
    jsonb_accessor :data,
      mbid: :string,
      title: :string,
      artist_name: :string

    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_album_data_schema.json')

    fetcher :mbid, [:mbid]
    fetcher :title_and_artist_name, [:title, :artist_name]
  end
end
