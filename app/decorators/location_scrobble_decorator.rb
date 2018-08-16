# frozen_string_literal: true

##
# Display logic for {LocationScrobble}s
#
class LocationScrobbleDecorator < ApplicationDecorator
  delegate_all

  def icon_tag(options = {})
    h.icon_tag(icon_class, options)
  end

  def icon_class
    object.place? ? 'fas fa-map-marker-alt' : 'fas fa-car'
  end

  def start_time
    h.friendly_format_time(object.start_time)
  end

  def end_time
    h.friendly_format_time(object.end_time)
  end

  def distance
    "#{object.distance == object.distance.to_i ? object.distance.to_i : object.distance}m"
  end
end
