# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! location_scrobble,
  :id, :name, :original_name,
  :distance, :trackpoints,
  :start_time, :end_time,
  :icon,
  :singular

json.type location_scrobble.friendly_type

json.category location_scrobble.category_name

json.average_latitude location_scrobble.latitude
json.average_longitude location_scrobble.longitude

json.is_transit location_scrobble.transit?
json.is_place location_scrobble.place?

json.place_id location_scrobble.place_id.to_s

json.place do
  if location_scrobble.transit?
    json.nil!
  else
    json.partial! 'places/place', place: location_scrobble.place.try(:decorate) || current_user.places.build.decorate
  end
end

json.partial! 'shared/model_props', model: location_scrobble
