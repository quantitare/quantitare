# frozen_string_literal: true

json.type 'Feature'

json.geometry do
  json.type location_scrobble.place? ? 'Point' : 'LineString'
  json.coordinates location_scrobble.geo_json_coordinates
end

json.properties do
  json.title location_scrobble.name
  json.color_primary location_scrobble.colors[:primary]
end
