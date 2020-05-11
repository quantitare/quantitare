# frozen_string_literal: true

json.key_format! camelize: :lower

json.type 'FeatureCollection'

json.features @location_scrobbles do |location_scrobble|
  json.cache! ['geojson_feature_v1', location_scrobble], expires_in: 10.minutes do
    json.partial! 'geojson_feature', location_scrobble: location_scrobble
  end
end
