# frozen_string_literal: true

module Aux
  ##
  # A wrapper for country data.
  #
  class Country < Carmen::Country
    extend Forwardable

    attr_reader :coded_country

    def_delegators :coded_country,
      :code, :alpha_2_code, :alpha_3_code,
      :name, :official_name,
      :subregions?

    class << self
      def all
        super.map { |coded_country| new(coded_country) }
      end

      def coded(code)
        coded_country = super
        coded_country ? new(coded_country) : nil
      end

      def named(name)
        coded_country = super
        coded_country ? new(coded_country) : nil
      end

      def query_collection
        superclass.all
      end
    end

    def initialize(coded_country)
      @coded_country = coded_country
    end

    def subregions
      coded_country.subregions.map { |coded_region| Aux::Region.new(coded_region) }
    end
  end
end
