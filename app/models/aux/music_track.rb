# frozen_string_literal: true

module Aux
  ##
  # A representation of a music track, shareable across scrobbles.
  #
  class MusicTrack < ServiceCache
    DATA_JSON_SCHEMA = Rails.root.join('app', 'models', 'json_schemas', 'aux', 'music_track_data_schema.json')

    validates :data, json_schema: { schema: DATA_JSON_SCHEMA }

    class << self
      def fetch(opts = {})
        adapter = opts[:adapter]

        if opts[:mbid].present?
          fetch_by_mbid(opts[:mbid], adapter: adapter)
        elsif opts[:title].present? && opts[:artist_name].present?
          fetch_by_title_and_artist(opts[:title], opts[:artist_name], adapter: adapter)
        else
          new(opts)
        end
      end

      def fetch_by_mbid(mbid, adapter:)
        cached = where(service: adapter.service).where("data->>'mbid' = ?", mbid).first

        return cached if cached.present? && !cached.expired?

        track = adapter.fetch_music_track(mbid: mbid)
        track.save!
        track
      end

      def fetch_by_title_and_artist(title, artist_name, adapter:)
        cached = where(service: adapter.service)
          .where("data->>'title' = ? AND data->>'artist_name' = ?", title, artist_name)

        return cached if cached.present? && !cached.expired?

        track = adapter.fetch_music_track(title: title, artist_name: artist_name)
        track.save!
        track
      end
    end
  end
end
