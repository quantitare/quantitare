# frozen_string_literal: true

module Aux
  ##
  # A representation of a music artist, shareable across scrobbles.
  #
  class MusicArtist < ServiceCache
    DATA_JSON_SCHEMA = Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_artist_data_schema.json')

    validates :data, json_schema: { schema: DATA_JSON_SCHEMA }

    class << self
      def fetch(opts = {})
        adapter = opts[:adapter]

        if opts[:mbid].present?
          fetch_by_mbid(opts[:mbid], adapter: adapter)
        elsif opts[:name].present?
          fetch_by_name(opts[:name], adapter: adapter)
        else
          new(opts)
        end
      end

      def fetch_by_mbid(mbid, adapter:)
        cached = where(service: adapter.service).where("data->>'mbid' = ?", mbid).first

        return cached if cached.present? && !cached.expired?

        new_cache = adapter.fetch_music_artist(mbid: mbid)
        new_cache.save!
        new_cache
      end

      def fetch_by_name(name, adapter:)
        cached = where(service: adapter.service)
          .where("data->>'name' = ?", name).first

        return cached if cached.present? && !cached.expired?

        new_cache = adapter.fetch_music_artist(name: name)
        new_cache.save!
        new_cache
      end
    end

    def mbid
      data[:mbid]
    end

    def name
      data[:name]
    end
  end
end
