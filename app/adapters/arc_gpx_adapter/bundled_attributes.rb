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

    def name
      prevailing(:name)
    end

    def category
      prevailing(:category)
    end

    def distance
      sum_of(:distance)
    end

    def trackpoints
      concatenated(:trackpoints).sort_by(&:time)
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

    def sum_of(attribute_name)
      bundle.placemarks.sum(&attribute_name.to_sym)
    end
  end
end
