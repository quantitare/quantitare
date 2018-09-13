# frozen_string_literal: true

json.key_format! camelize: :lower

json.array! @places do |place|
  json.id place.id.to_s

  json.extract! place,
    :name, :category, :description,
    :street_1, :street_2, :city, :state, :zip, :country,
    :longitude, :latitude

  json.icon place.category_icon
end
