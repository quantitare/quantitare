# frozen_string_literal: true

##
# Transit-specific data for LocationCategory
#
class TransitCategory < LocationCategory
  DATA_PATH = Rails.root.join('app', 'data', 'transit_categories.yml')
  DEFAULT_ICON = { type: 'fa', name: 'map-marker-alt' }.freeze
end
