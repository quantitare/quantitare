# frozen_string_literal: true

##
# Place-specific data for {LocationCategory}s
#
class PlaceCategory < LocationCategory
  DATA_PATH = Rails.root.join('app', 'data', 'place_categories.yml').freeze
  DEFAULT_ICON = Icon.for(:fa, name: 'fas fa-map-marker-alt')
end
