# frozen_string_literal: true

class WithingsAdapter
  ##
  # @private
  #
  class SeriesSample < WithingsAdapter::Sample
    def data
      attributes = config[:fields].map do |fields|
        [fields[:key], response_data[fields[:value]]]
      end.to_h

      attributes.any? { |_, value| value.blank? } ? nil : attributes
    end
  end
end
