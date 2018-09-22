# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! @location_scrobble,
  :id, :name,
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
