# frozen_string_literal: true

##
# Place-specific data for {LocationCategory}s
#
class PlaceCategory < LocationCategory
  DATA_PATH = Rails.root.join('app', 'data', 'place_categories.yml')
  DEFAULT_ICON = { type: 'fa', name: 'map-marker-alt' }
end
