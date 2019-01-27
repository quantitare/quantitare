# frozen_string_literal: true

class ArcGPXAdapter
  ##
  # Extracts Placemark attributes from a bundle of attributable objects.
  #
  class BundledAttributes
    attr_reader :bundle

    def initialize(bundle)
      @bundle = bundle
    end

    def type
      prevailing(:type)
    end

    def name
      prevailing(:name)
    end

    def category
      prevailing(:category)
    end

    def description
      first(:description)
    end

    def distance
      sum_of(:distance)
    end

    def trackpoints
      concatenated(:trackpoints).sort_by(&:timestamp)
    end

    private

    def prevailing(attribute_name)
      counts = Hash.new { |h, k| h[k] = 0 }

      bundle.placemarks.each do |placemark|
        attribute = placemark.public_send(attribute_name)
        next if attribute.blank?

        counts[attribute] += 1
      end

      max = counts.max { |(_k1, v1), (_k2, v2)| v1 <=> v2 }
      max && max[0]
    end

    def first(attribute_name)
      placemark = bundle.placemarks.find { |placemark| placemark.public_send(attribute_name).present? }

      placemark.present? ? placemark.public_send(attribute_name) : nil
    end

    def sum_of(attribute_name)
      bundle.placemarks.sum do |placemark|
        placemark.public_send(attribute_name).presence || 0
      end
    end

    def concatenated(attribute_name)
      bundle.placemarks.flat_map(&attribute_name.to_sym).compact
    end
  end
end
