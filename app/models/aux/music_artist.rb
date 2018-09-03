# frozen_string_literal: true

module Aux
  ##
  # A representation of a music artist, shareable across scrobbles.
  #
  class MusicArtist < ServiceCache
    store_accessor :data, :mbid, :name

    json_schema :data, Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_artist_data_schema.json')

    fetcher :mbid, [:mbid]
    fetcher :name, [:name]
  end
end
