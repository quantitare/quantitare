# frozen_string_literal: true

##
# Transit-specific data for LocationCategory
#
class TransitCategory < LocationCategory
  DATA_PATH = Rails.root.join('app', 'data', 'transit_categories.yml')
  DEFAULT_ICON = 'map-marker-alt'
end
