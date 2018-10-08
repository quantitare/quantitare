# frozen_string_literal: true

class LastfmAdapter
  ##
  # Converts raw music album data from the Last.fm API to a {Aux::MusicAlbum}
  #
  class MusicAlbum
    attr_reader :raw_album, :service

    def initialize(raw_album, service:)
      @raw_album = raw_album.with_indifferent_access
      @service = service
    end

    def to_aux
      Aux::MusicAlbum.new(
        service: service,
        service_identifier: service_identifier,
        data: data,
        tag_list: tag_list,

        expires_at: 1.month.from_now
      )
    end

    private

    def service_identifier
      raw_album[:mbid]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def data
      {
        mbid: raw_album[:mbid],

        title: raw_album[:name],
        release_date: raw_album[:releasedate],

        artist_name: raw_album[:artist],
        artist_mbid: find_artist_mbid,

        tracks: tracks_data,

        image: {
          small: image_for(:small),
          medium: image_for(:medium),
          large: image_for(:large),
          original: image_for(:mega) || image_for(:extralarge) || image_for(:large)
        }.compact,

        info: {
          summary: raw_album[:wiki][:summary],
          content: raw_album[:wiki][:content]
        }.compact
      }.compact
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def find_artist_mbid
      raw_track_info.find do |track_info|
        track_info[:artist][:name] == raw_album[:artist]
      end[:artist][:mbid]
    end

    def tracks_data
      raw_track_info.map do |track_info|
        {
          rank: track_info[:rank].to_i,
          title: track_info[:name],
          mbid: track_info[:mbid],

          artist_name: track_info[:artist][:name],
          artist_mbid: track_info[:artist][:mbid]
        }.compact
      end
    end

    def image_for(size)
      raw_album[:image].find { |image_info| image_info[:size] == size.to_s }.with_indifferent_access[:content]
    end

    def tag_list
      (raw_album.dig(:toptags, :tag) || raw_album.dig(:tags, :tag)).map do |tag_info|
        tag_info.with_indifferent_access[:name]
      end.compact.join(', ')
    end

    def raw_track_info
      raw_album[:tracks][:track]
    end
  end
end
