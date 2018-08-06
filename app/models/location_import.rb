# frozen_string_literal: true

##
# A wrapper for a location import file.
#
class LocationImport < ApplicationRecord
  include HasGuid

  has_many :location_scrobbles
  has_one_attached :import_file

  @adapters = []

  class << self
    attr_reader :adapters

    def add_adapter(adapter_klass)
      adapters << adapter_klass
    end
  end

  add_adapter GoogleMapsKmlAdapter
end
