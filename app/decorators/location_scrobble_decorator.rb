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

  def icon_tag(options = {})
    h.icon_tag(icon_class, options)
  end

  def icon
    object.category_info.icon.with_indifferent_access
  end

  def icon_class
    "fas fa-#{icon[:name].downcase}"
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
    "#{object.distance == object.distance.to_i ? object.distance.to_i : object.distance}m"
  end

  def geo_json_coordinates
    if place?
      [longitude.to_f, latitude.to_f]
    else
      trackpoints.map { |trackpoint| [trackpoint['longitude'], trackpoint['latitude']] }
    end
  end
end
