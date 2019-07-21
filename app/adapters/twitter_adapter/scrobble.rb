# frozen_string_literal: true

class TwitterAdapter
  ##
  # @private
  #
  class Scrobble
    class << self
      def from_api(data)
        new(data).to_scrobble
      end
    end

    attr_reader :raw_tweet

    def initialize(raw_tweet)
      @raw_tweet = raw_tweet
    end

    def to_scrobble
      ::Scrobble.new(
        category: 'social_share',
        timestamp: raw_tweet.created_at,

        data: data
      )
    end

    private

    def data
      {
        content: raw_tweet.text,

        type: type,
        service: 'twitter',

        urls: urls,
        media: media,

        counters: {
          favorites: raw_tweet.favorite_count,
          reshares: raw_tweet.retweet_count
        },

        is_reshare: raw_tweet.retweet?,
        is_reply: raw_tweet.reply?
      }.deep_merge(optional_data)
    end

    def type
      case raw_tweet.media.first
      when ::Twitter::Media::Photo
        'photo'
      when ::Twitter::Media::Video
        'video'
      when ::Twitter::Media::AnimatedGif
        'animation'
      else
        'text'
      end
    end

    def urls
      raw_tweet.urls.map(&:expanded_url).map(&:to_s)
    end

    def media
      raw_tweet.media.map { |raw_media| media_attributes_for_raw(raw_media) }
    end

    def media_attributes_for_raw(raw_media)
      case raw_media
      when ::Twitter::Media::Photo
        { type: 'photo', src: raw_media.media_url_https.to_s }
      when ::Twitter::Media::Video
        { type: 'video', src: raw_media.video_info.variants.max_by(&:bitrate).url.to_s }
      when ::Twitter::Media::AnimatedGif
        { type: 'animation', src: raw_media.video_info.variants.max_by(&:bitrate).url.to_s }
      end
    end

    def optional_data
      result = {}

      result[:reshare_info] = reshare_info if raw_tweet.retweet?
      result[:reply_info] = reply_info if raw_tweet.reply?
      result[:counters] = { reply_count: raw_tweet.reply_count } if raw_tweet.try(:reply_count)

      result
    end

    def reshare_info
      {
        resharee_username: raw_tweet.retweeted_status.user.screen_name,
        resharee_display_name: raw_tweet.retweeted_status.user.name
      }
    end

    def reply_info
      {
        replyee_username: raw_tweet.in_reply_to_screen_name
      }
    end
  end
end
