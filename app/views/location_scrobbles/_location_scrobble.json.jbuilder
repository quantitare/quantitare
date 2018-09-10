# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! @location_scrobble, :name, :type, :category, :distance, :place_id, :start_time, :end_time

json.is_transit @location_scrobble.transit?
json.is_place @location_scrobble.place?

json.url location_scrobble_path(@location_scrobble)

json.errors @location_scrobble.errors.messages

json.place do
  json.name @location_scrobble.place.try(:name)
  json.category @location_scrobble.place.try(:category)

  json.street_1 @location_scrobble.place.try(:street_1)
  json.street_2 @location_scrobble.place.try(:street_2)
  json.city @location_scrobble.place.try(:city)
  json.state @location_scrobble.place.try(:state)
  json.zip @location_scrobble.place.try(:zip)
  json.country @location_scrobble.place.try(:country)

  json.latitude @location_scrobble.place.try(:latitude)
  json.longitude @location_scrobble.place.try(:longitude)

  json.global @location_scrobble.place.try(:global)

  json.isCustom @location_scrobble.place.try(:custom?)

  json.url location_scrobble_place_path(@location_scrobble)

  json.errors @location_scrobble.place.try(:errors).try(:messages) || {}
end
