# frozen_string_literal: true

json.key_format! camelize: :lower

json.scrobbles do
  json.array! @scrobbles do |scrobble|
    json.extract! scrobble,
      :category, :data, :guid, :start_time, :end_time
  end
end

json.location_scrobbles do
  json.array! @location_scrobbles do |location_scrobble|
    json.extract! location_scrobble,
      :name
  end
end
