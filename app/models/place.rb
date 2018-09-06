# frozen_string_literal: true

##
# A place
#
class Place < ApplicationRecord
  include HasGuid

  FULL_ADDRESS_ATTRS = [:address1, :address2, :city, :state, :country].freeze
  COORDINATES_ATTRS = [:latitude, :longitude].freeze

  has_many :location_scrobbles, dependent: :nullify
  belongs_to :user, optional: true

  after_validation :geocode, if: ->(obj) { obj.requires_geocode? }
  after_validation :reverse_geocode, if: ->(obj) { obj.requires_reverse_geocode? }

  scope :available_to_user, ->(user) { where(global: true).or(where(user: user)) }

  geocoded_by :full_address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    return unless geo

    obj.address1 = geo.street
    obj.city = geo.city
    obj.state = geo.state_code
    obj.zip = geo.postal_code
    obj.country = geo.country
  end

  def full_address
    full_address_values.compact.join(', ')
  end

  def full_address_values
    attributes_from_set(FULL_ADDRESS_ATTRS)
  end

  def full_address_changed?
    attributes_from_set_changed?(FULL_ADDRESS_ATTRS)
  end

  def coordinates
    attributes_from_set(COORDINATES_ATTRS)
  end

  def coordinates_changed?
    attributes_from_set_changed?(COORDINATES_ATTRS)
  end

  def requires_geocode?
    full_address.present? && (full_address_changed? && !coordinates_changed?)
  end

  def requires_reverse_geocode?
    coordinates_changed? && (coordinates_changed? && !full_address_changed?)
  end

  private

  def attributes_from_set(attr_names)
    attr_names.map { |attr_name| send(attr_name) }
  end

  def attributes_from_set_changed?(attr_names)
    attr_names.any? { |attr_name| send("#{attr_name}_changed?") }
  end
end
