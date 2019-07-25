# frozen_string_literal: true

class FlickrAdapter
  ##
  # @private
  #
  class Photo
    attr_reader :raw_photo, :adapter

    def initialize(raw_photo, adapter)
      @raw_photo = raw_photo
      @adapter = adapter
    end

    def to_aux
      ::Aux::Flickr::Photo.new(
        service: adapter.service,
        service_identifier: photo_id,

        data: data,
        tag_list: tag_list,

        expires_at: 1.month.from_now
      )
    end

    private

    def photo_id
      raw_photo['id'].to_i
    end

    # rubocop:disable Metrics/AbcSize
    def data
      {
        id: photo_id,

        title: raw_photo['title'].to_s,
        description: raw_photo['description'].to_s,

        type: raw_photo['media'].to_s,
        url: url,

        favorites: adapter.fetch_favorites_count_for_photo(photo_id),
        comments: raw_photo['comments'].to_i,

        location: location,

        uploaded_at: uploaded_at,
        taken_at: taken_at,

        user: user
      }
    end
    # rubocop:enable Metrics/AbcSize

    def tag_list
      raw_photo['tags'].map { |t| t['_content'] }
    end

    def url
      "https://farm#{raw_photo['farm']}.staticflickr.com/#{raw_photo['server']}/" \
        "#{raw_photo['id']}_#{raw_photo['originalsecret']}_o.#{raw_photo['originalformat']}"
    end

    def location
      {
        longitude: location_info('longitude'),
        latitude: location_info('latitude')
      }
    end

    def uploaded_at
      Time.zone.at(raw_photo['dates']['posted'].to_i)
    end

    def taken_at
      date_str = raw_photo['dates']['taken']
      date_str.present? ? Time.zone.parse(date_str) : uploaded_at
    end

    def user
      {
        id: raw_photo['owner']['nsid'],
        username: raw_photo['owner']['username'],
        display_name: raw_photo['owner']['realname']
      }
    end

    def location_info(property)
      value = raw_photo.try(:location).try(property)

      value.nil? ? nil : value.to_f
    end
  end
end
