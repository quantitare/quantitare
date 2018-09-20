# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! @location_scrobble,
  :name,
  :distance, :trackpoints,
  :start_time, :end_time,
  :icon

json.type @location_scrobble.friendly_type

json.category @location_scrobble.category_name

json.average_latitude @location_scrobble.average_latitude
json.average_longitude @location_scrobble.average_longitude

json.is_transit @location_scrobble.transit?
json.is_place @location_scrobble.place?

json.place_id @location_scrobble.place_id.to_s

json.url location_scrobble_path(@location_scrobble)
json.isNewRecord @location_scrobble.new_record?
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
  json.isNewRecord @location_scrobble.place.try(:new_record?)
  json.errors @location_scrobble.place.try(:errors).try(:messages) || {}
end
