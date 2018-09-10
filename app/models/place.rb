# frozen_string_literal: true

##
# A place
#
class Place < ApplicationRecord
  include HasGuid

  FULL_ADDRESS_ATTRS = [:street_1, :street_2, :city, :state, :country].freeze
  COORDINATES_ATTRS = [:latitude, :longitude].freeze

  has_many :location_scrobbles, dependent: :nullify
  belongs_to :user, optional: true

  validates :name, presence: true
  validates :category, presence: true
  validate :address_or_coordinates_must_be_present

  after_validation :geocode, if: ->(obj) { obj.requires_geocode? }
  after_validation :reverse_geocode, if: ->(obj) { obj.requires_reverse_geocode? }

  scope :available_to_user, ->(user) { where(global: true).or(where(user: user)) }

  geocoded_by :full_address
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    geo = results.first
    return unless geo

    obj.street_1 = geo.street
    obj.city = geo.city
    obj.state = geo.state_code
    obj.zip = geo.postal_code
    obj.country = geo.country
  end

  def custom?
    service_id.nil?
  end

  def full_address
    full_address_values.reject(&:blank?).join(', ')
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

  def address_or_coordinates_must_be_present
    errors[:base] << 'Address or coordinates must be present' unless address_or_coordinates_present?
  end

  def address_or_coordinates_present?
    full_address.present? || coordinates.reject(&:blank?).present?
  end

  def attributes_from_set(attr_names)
    attr_names.map { |attr_name| send(attr_name) }
  end

  def attributes_from_set_changed?(attr_names)
    attr_names.any? { |attr_name| send("#{attr_name}_changed?") }
  end
end
