# frozen_string_literal: true

##
# Transit-specific data for LocationCategory
#
class TransitCategory < LocationCategory
  DATA_PATH = Rails.root.join('app/data/transit_categories.yml')
  DEFAULT_ICON = Icon.for(:fa, name: 'fas fa-map-marker-alt')
end
