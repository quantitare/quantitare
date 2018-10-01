# frozen_string_literal: true

##
# A place
#
class Place < ApplicationRecord
  include HasGuid
  include Categorizable
  include ServiceFetchable

  FETCHER_KLASS = Place::Fetcher
  CATEGORY_KLASS = PlaceCategory

  FULL_ADDRESS_ATTRS = [:street_1, :street_2, :city, :state, :zip, :country].freeze
  COORDINATES_ATTRS = [:longitude, :latitude].freeze

  belongs_to :user, optional: true
  belongs_to :service, optional: true
  has_many :location_scrobbles, dependent: :nullify
  has_many :place_matches, dependent: :nullify

  validates :name, presence: true
  validates :category, presence: true
  validate :address_or_coordinates_must_be_present
  validate :all_coordinates_must_be_present_if_present

  after_validation :geocode, if: ->(obj) { obj.requires_geocode? }
  after_validation :reverse_geocode, if: ->(obj) { obj.requires_reverse_geocode? }

  scope :available_to_user, ->(user) { where(global: true).or(where(user: user)) }

  geocoded_by :full_address
  reverse_geocoded_by :longitude, :latitude do |obj, results|
    geo = results.first

    if geo
      obj.street_1 = "#{geo.data['address']} #{geo.data['text']}".strip
      obj.city = geo.city
      obj.state = geo.state_code
      obj.zip = geo.postal_code
      obj.country = geo.country
    end
  end

  fetcher :service_identifier, [:service_identifier]

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

  def all_coordinates_must_be_present_if_present
    return if both_coordinate_values_present? || coordinates.compact.blank?

    errors[:base] << 'Both latitude and longitude (or neither) must be present'
  end

  def address_or_coordinates_present?
    full_address.present? || coordinates.reject(&:blank?).present?
  end

  def both_coordinate_values_present?
    longitude.present? && latitude.present?
  end

  def attributes_from_set(attr_names)
    attr_names.map { |attr_name| send(attr_name) }
  end

  def attributes_from_set_changed?(attr_names)
    attr_names.any? { |attr_name| send("#{attr_name}_changed?") }
  end
end
