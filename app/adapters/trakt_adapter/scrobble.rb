# frozen_string_literal: true

class TraktAdapter
  ##
  # @private
  #
  class Scrobble
    CATEGORIES_TO_SCROBBLE_KLASSES = { tv: TraktAdapter::TVScrobble, movie: TraktAdapter::MovieScrobble }.freeze

    class << self
      def from_api(response, categories: CATEGORY_MAPPINGS.keys)
        verify_response(response)

        response.body.map do |raw_scrobble|
          next unless raw_scrobble['type'].in?(source_types_for_categories(categories))

          generator_for_raw(raw_scrobble).to_scrobble
        end.compact
      end

      def verify_response(response)
      end

      private

      def generator_for_raw(raw_scrobble)
        CATEGORIES_TO_SCROBBLE_KLASSES[category_for_type(raw_scrobble['type']).to_sym].new(raw_scrobble)
      end

      def source_types_for_categories(categories = [])
        categories.flat_map { |category| CATEGORY_MAPPINGS[category.to_sym] }
      end

      def category_for_type(type)
        CATEGORY_MAPPINGS.keys.find { |key| Array(CATEGORY_MAPPINGS[key]).include?(type.to_s) }
      end
    end
  end
end
