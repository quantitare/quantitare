# frozen_string_literal: true

##
# A wrapper for a location import file.
#
class LocationImport < ApplicationRecord
  include HasGuid

  has_many :location_scrobbles, as: :source, dependent: :destroy
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

  def source_identifier
    adapter
  end

  def interval
    [
      location_scrobbles.min_by(&:start_time).start_time,
      location_scrobbles.max_by(&:end_time).end_time
    ]
  end

  def prepared_adapter
    preparable_adapter? ? adapter_klass.for_location_import(self) : nil
  end

  def preparable_adapter?
    adapter_klass.present? && import_file.attachment.present?
  end

  def adapter_klass
    adapter.nil? ? nil : adapter.constantize
  end

  add_adapter GoogleMapsKmlAdapter
end
