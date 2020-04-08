# frozen_string_literal: true

json.key_format! camelize: :lower

json.scrobbles location_scrobbles, partial: 'location_scrobble', as: :location_scrobble

json.geojson do
  json.places do
    json.partial! 'location_scrobbles/geo_json',
      location_scrobbles: location_scrobbles.select(&:place?).uniq { |scrobble| scrobble.place_id || scrobble.name }
  end

  json.transits do
    json.partial! 'location_scrobbles/geo_json', location_scrobbles: location_scrobbles.select(&:transit?)
  end
end
