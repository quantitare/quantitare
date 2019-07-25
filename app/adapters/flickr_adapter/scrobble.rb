# frozen_string_literal: true

class FlickrAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def photo_from_api(photo, raw_photo_activity)
        new(photo, raw_photo_activity).to_scrobble
      end
    end

    attr_reader :photo, :raw_photo_activity

    def initialize(photo, raw_photo_activity)
      @photo = photo
      @raw_photo_activity = raw_photo_activity
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'social_share',
        timestamp: photo.data['uploaded_at'],

        data: data
      )
    end

    private

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def data
      {
        content: content,

        type: photo.data['type'],
        service: 'flickr',

        urls: [],

        media: media,

        counters: {
          favorites: photo.data['favorites'],
          replies: photo.data['comments']
        },

        is_reshare: false,
        is_reply: false,

        location: {
          longitude: photo.data['location']['longitude'],
          latitude: photo.data['location']['latitude']
        }
      }
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def content
      "#{photo.data['title']}\n\n#{photo.data['description']}"
    end

    def media
      [{ type: photo.data['type'], src: photo.data['url'] }]
    end
  end
end
