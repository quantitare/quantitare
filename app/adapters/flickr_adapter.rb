# frozen_string_literal: true

##
# API wrapper for the Flickr API
#
class FlickrAdapter
  CONFIG_ERROR_CODES = [1, 100, 111, 112, 114, 115, 116].freeze
  API_ERROR_CODES = [105].freeze

  attr_reader :service, :cadence

  def initialize(service, cadence: 0.seconds)
    @service = service
    @cadence = cadence
  end

  def client
    @client ||= Flickr.new(service.provider_key, service.provider_secret).tap do |flickr|
      flickr.access_token = service.token
      flickr.access_secret = service.secret
    end
  end

  def fetch_scrobbles(start_time, end_time)
    fetch_raw_photo_activity(start_time, end_time)
      .map { |raw_photo| scrobble_from_raw_photo_activity(raw_photo) }
  end

  def fetch_photo(params = {})
    FlickrAdapter::Photo.new(fetch_raw_photo(params[:id]), self).to_aux
  end

  def fetch_favorites_count_for_photo(photo_id)
    wrap_api_call { client.photos.getFavorites(photo_id: photo_id)['total'].to_i }
  end

  private

  def wrap_api_call
    result = yield

    sleep cadence

    result
  rescue Flickr::FailedResponse => e
    handle_failed_response(e)
  rescue Errno::EHOSTUNREACH
    raise Errors::ServiceAPIError
  end

  def handle_failed_response(error)
    raise Errors::ServiceConfigError if error.code.to_i.in? CONFIG_ERROR_CODES
    raise Errors::ServiceAPIError if error.code.to_i.in? API_ERROR_CODES

    raise error
  end

  def fetch_raw_photo_activity(start_time, end_time, page: 1, list: [])
    new_list = wrap_api_call do
      client.people.getPhotos(
        user_id: service.uid, min_upload_date: start_time.to_i, max_upload_date: end_time.to_i, page: page
      ).to_a
    end

    return list if new_list.blank?

    fetch_raw_photo_activity(start_time, end_time, page: page + 1, list: list + new_list)
  end

  def fetch_raw_photo(photo_id)
    wrap_api_call { client.photos.getInfo(photo_id: photo_id) }
  end

  def scrobble_from_raw_photo_activity(raw_photo_activity)
    photo = Aux::Flickr::Photo.fetch(id: raw_photo_activity['id'].to_i, adapter: self)

    FlickrAdapter::Scrobble.photo_from_api(photo, raw_photo_activity)
  end
end
