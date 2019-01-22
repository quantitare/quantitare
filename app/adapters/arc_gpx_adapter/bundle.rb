# frozen_string_literal: true

class ArcGPXAdapter
  # @private
  class Bundle
    delegate :empty?, to: :placemarks

    def placemarks
      @placemarks ||= []
    end

    def push(placemark)
      raise ArgumentError unless can_absorb?(placemark)

      placemarks << placemark
    end

    alias << push
    alias absorb push

    def can_absorb?(placemark)
      placemarks.none?(&:place?) && (
        empty? ||
        stationary_placemark?(placemark) ||
        placemarks.all? { |existing| stationary_placemark?(existing) || existing.category == placemark.category }
      )
    end

    def compile
      ArcGPXAdapter::BundledAttributes.new(self)
    end

    private

    def stationary_placemark?(placemark)
      placemark.category.nil? || placemark.category.casecmp('stationary').zero?
    end
  end
end
