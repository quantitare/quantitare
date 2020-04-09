# frozen_string_literal: true

class FoursquareAdapter
  ##
  # Translates data for a place returned by the Foursquare API into a {Place} model.
  #
  class Place
    DEFAULT_CATEGORY_ID = '4bf58dd8d48988d130941735'

    attr_reader :raw_place, :service

    def initialize(raw_place, service:)
      @raw_place = raw_place
      @service = service
    end

    # @return [Place] an initialized {Place} with +raw_place+'s attributes
    #
    # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
    def to_aux
      ::Place.new(
        user: service.user,
        service: service,
        service_identifier: raw_place[:id],
        global: true,

        name: raw_place[:name],
        category: category_id,

        longitude: raw_place[:location][:lng],
        latitude: raw_place[:location][:lat],

        street_1: raw_place[:location][:address],
        city: raw_place[:location][:city],
        state: raw_place[:location][:state],
        zip: raw_place[:location][:postalCode],
        country: raw_place[:location][:country],

        expires_at: 1.week.from_now
      )
    end
    # rubocop:enable Metrics/MethodLength, Metrics/AbcSize

    private

    def category_id
      raw_place[:categories].find { |category| category[:primary] }.try(:dig, :id) || DEFAULT_CATEGORY_ID
    end
  end
end
