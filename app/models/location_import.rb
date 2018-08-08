# frozen_string_literal: true

##
# A wrapper for a location import file.
#
class LocationImport < ApplicationRecord
  include HasGuid

  has_many :location_scrobbles, as: :source
  belongs_to :user
  has_one_attached :import_file

  validates :user, presence: true
  validates :adapter, presence: true

  @adapters = []

  class << self
    attr_reader :adapters

    def add_adapter(adapter_klass)
      adapters << adapter_klass
    end
  end

  def adapter
    self[:adapter].nil? ? nil : Object.const_get(self[:adapter])
  end

  add_adapter GoogleMapsKmlAdapter
end
