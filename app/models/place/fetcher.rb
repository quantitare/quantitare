# frozen_string_literal: true

class Place
  ##
  # {ServiceFetchable::Fetcher} variant for places. Exhibits slightly different behavior from a normal
  # {ServiceFetchable}, but the idea is the same.
  #
  class Fetcher < ServiceFetchable::Fetcher
    private

    def find_cached(cache_klass, service, opts = {})
      relation = cache_klass
        .where(service: service)
        .where(keyword_attributes(opts))

      relation.first
    end

    def merge_attributes
      [
        :name, :street_1, :street_2, :city, :state, :zip, :country,
        :longitude, :latitude,
        :category, :description,
        :expires_at
      ]
    end
  end
end
