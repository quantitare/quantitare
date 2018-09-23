# frozen_string_literal: true

module Aux
  ##
  # A wrapper class for a country's subregions
  #
  class Region
    attr_reader :coded_region

    delegate :name, :code, :type, to: :coded_region

    def initialize(coded_region)
      @coded_region = coded_region
    end
  end
end
