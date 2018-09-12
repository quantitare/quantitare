# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  include Periodable

  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :source, polymorphic: true

  default_scope -> { order(start_time: :asc) }

  class << self
    def category_klass
      const_get('CATEGORY_KLASS')
    end
  end

  def place?
    is_a? PlaceScrobble
  end

  def transit?
    is_a? TransitScrobble
  end

  def friendly_type
    raise NotImplementedError
  end

  def category_klass
    self.class.category_klass
  end

  def category_info
    category_klass.find(category) || category_klass.default
  end

  def category_name
    category_info.name
  end

  def average_latitude
    trackpoint_average(:latitude)
  end

  def average_longitude
    trackpoint_average(:longitude)
  end

  private

  def trackpoint_average(attribute)
    trackpoints.map { |trackpoint| trackpoint.with_indifferent_access[attribute] }.sum / trackpoints.length
  end
end
