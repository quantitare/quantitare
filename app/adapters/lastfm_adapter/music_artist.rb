# frozen_string_literal: true

class LastfmAdapter
  ##
  # Converts raw artist data from Last.fm to an {Aux::MusicArtist}
  #
  class MusicArtist
    attr_reader :raw_artist, :service

    def initialize(raw_artist, service:)
      @raw_artist = raw_artist.with_indifferent_access
      @service = service
    end

    def to_aux
      Aux::MusicArtist.new(
        service: service,
        data: data,
        tag_list: tag_list,

        expires_at: 1.month.from_now
      )
    end

    private

    # rubocop:disable Metrics/AbcSize
    def data
      {
        mbid: raw_artist[:mbid],
        name: raw_artist[:name],

        bio: {
          summary: raw_artist[:bio][:summary],
          content: raw_artist[:bio][:content]
        }.compact,

        image: {
          small: image_for(:small),
          medium: image_for(:medium),
          large: image_for(:large),
          original: image_for(:mega) || image_for[:extralarge] || image_for[:large]
        }.compact
      }.compact
    end
    # rubocop:enable Metrics/AbcSize

    def tag_list
      raw_artist[:tags][:tag].map { |tag_info| tag_info[:name] }.join(', ')
    end

    def image_for(size)
      raw_artist[:image].find { |image_info| image_info[:size] == size.to_s }[:content]
    end
  end
end
