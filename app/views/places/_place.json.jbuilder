# frozen_string_literal: true

json.key_format! camelize: :lower

json.id place.id.to_s

json.extract! place,
  :name, :category, :description,
  :street_1, :street_2, :city, :state, :zip, :country,
  :longitude, :latitude, :global

json.icon place.category_icon

json.url url_for(place)
json.isNewRecord place.new_record?
json.errors place.errors.messages
