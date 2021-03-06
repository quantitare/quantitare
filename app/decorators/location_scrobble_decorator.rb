# frozen_string_literal: true

##
# Display logic for {LocationScrobble}s
#
class LocationScrobbleDecorator < ApplicationDecorator
  delegate_all

  def name
    object.place.try(:name) || object.name
  end

  def original_name
    object.name
  end

  def icon_tag(**props)
    h.icon_tag(icon, **props)
  end

  def icon
    object.category_info.icon
  end

  def colors
    (object.category_info.colors || {}).with_indifferent_access
  end

  def friendly_start_time
    h.friendly_format_time(object.start_time)
  end

  def friendly_end_time
    h.friendly_format_time(object.end_time)
  end

  def distance
    base =
      if object.distance_traveled == object.distance_traveled.to_i
        object.distance_traveled.to_i
      else
        object.distance_traveled
      end

    "#{base}m"
  end

  def geo_json_coordinates
    if place?
      [longitude.to_f, latitude.to_f]
    else
      trackpoints.map { |trackpoint| [trackpoint['longitude'], trackpoint['latitude']] }
    end
  end
end
