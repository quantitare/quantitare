# frozen_string_literal: true

class FoursquareAdapter
  ##
  # Converts a list of categories from the Foursquare API to a {ServiceCache} object.
  #
  class PlaceCategoryList
    attr_reader :raw_list, :service

    def initialize(raw_list, service:)
      @raw_list = raw_list
      @service = service
    end

    def to_aux
      Aux::PlaceCategoryList.new(
        service: service,
        data: data,

        expires_at: 1.week.from_now
      )
    end

    private

    def data
      category_map = {}

      raw_list
        .map { |category| category.deep_transform_keys(&:underscore) }
        .map(&:with_indifferent_access)
        .each { |raw_category| add_category_to_category_map!(raw_category, category_map) }

      { provider: service.provider, categories: category_map }
    end

    def add_category_to_category_map!(raw_category, category_map)
      category_map[raw_category[:id]] = raw_category.except(:categories)

      return if raw_category[:categories].blank?

      raw_category[:categories].each { |raw_subcategory| add_category_to_category_map!(raw_subcategory, category_map) }
    end
  end
end
