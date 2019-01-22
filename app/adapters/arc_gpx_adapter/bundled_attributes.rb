# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Extracts Placemark attributes from a bundle of XML nodes.
  #
  class BundledAttributes
    attr_reader :bundle

    def initialize(bundle)
      @bundle = bundle
    end

    def type
      prevailing(:type)
    end

    def category
      prevailing(:category)
    end

    private

    def prevailing(attribute)
      bundle.placemarks.max_by { |placemark| placemark.public_send(attribute).presence || -Float::INFINITY }
    end
  end
end
