# frozen_string_literal: true

class FoursquareAdapter
  ##
  # Takes raw place-category data from the Forusquare API and turns it in to an {Aux::PlaceCategory} record.
  #
  class PlaceCategory
    attr_reader :raw_category, :service

    def initialize(raw_category, service:)
      @raw_category = raw_category
      @service = service
    end

    def to_aux
      Aux::PlaceCategory.new(
        service: service,
        data: data,

        expires_at: 1.week.from_now
      )
    end

    private

    def data
      { provider: service.provider }.merge(category_params)
    end

    def category_params
      {
        id: raw_category[:id],
        name: raw_category[:name],
        plural_name: raw_category[:plural_name],

        icon: icon_params
      }
    end

    def icon_params
      {
        type: 'img',

        sm: icon_url(32),
        md: icon_url(44),
        lg: icon_url(64),
        xl: icon_url(88),

        sm_dark: icon_url(32, true),
        md_dark: icon_url(44, true),
        lg_dark: icon_url(64, true),
        xl_dark: icon_url(88, true)
      }
    end

    def icon_url(size, dark = false)
      icon = raw_category[:icon]
      "#{icon[:prefix]}#{dark ? 'bg_' : ''}#{size}#{icon[:suffix]}"
    end
  end
end
