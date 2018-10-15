# frozen_string_literal: true

json.key_format! camelize: :lower

json.id place.id.to_s

json.extract! place,
  :name, :category, :description,
  :street_1, :street_2, :city, :state, :zip, :country,
  :longitude, :latitude, :global

json.icon place.category_icon
json.isCustom place.custom?

json.partial! 'shared/model_props', model: place
