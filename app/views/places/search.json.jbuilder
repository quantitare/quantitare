# frozen_string_literal: true

json.key_format! camelize: :lower

groups = [
  { label: 'Custom places', id: 1, places: @custom_places },
  { label: 'Global places', id: 2, places: @global_places }
]

json.array!(groups) do |group|
  json.label group[:label]
  json.id group[:id]

  json.places group[:places], partial: 'place', as: :place
end
