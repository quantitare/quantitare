# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! place_match,
  :enabled, :to_delete, :match_name, :match_coordinates

json.partial! 'shared/model_props', model: place_match
