# frozen_string_literal: true

class LastfmAdapter
  ##
  # Converts raw music track data from the Last.fm API to an {Aux::MusicTrack}.
  #
  class MusicTrack
    attr_reader :raw_track, :service

    def initialize(raw_track, service:)
      @raw_track = raw_track.with_indifferent_access
      @service = service
    end

    def to_aux
      Aux::MusicTrack.new(
        service: service,
        data: data,
        tag_list: tag_list,

        expires_at: 1.month.from_now
      )
    end

    # rubocop:disable Metrics/AbcSize
    def data
      {
        mbid: raw_track[:mbid],

        title: raw_track[:name],
        duration: raw_track[:duration].to_i,

        artist_name: raw_track[:artist][:name],
        artist_mbid: raw_track[:artist][:mbid],

        album_title: raw_track.dig(:album, :title),
        album_mbid: raw_track.dig(:album, :mbid)
      }.compact
    end
    # rubocop:enable Metrics/AbcSize

    def tag_list
      raw_track[:toptags][:tag].map { |tag_info| tag_info.with_indifferent_access[:name] }.join(', ')
    end
  end
end
