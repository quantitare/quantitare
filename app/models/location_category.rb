# frozen_string_literal: true

##
# Rep
#
class LocationCategory
  class << self
    DATA_PATH = Rails.root.join('app', 'data', 'location_categories.yml')
    DEFAULT_ICON = 'map-marker-alt'

    def all
      YAML.load_file(DATA_PATH).map do |category_hash|
        new(category_hash['name'], category_hash['icon'] || DEFAULT_ICON)
      end
    end
  end

  attr_reader :name, :icon

  def initialize(name, icon = DEFAULT_ICON)
    @name = name
    @icon = icon
  end

  def to_h
    {
      name: name,
      icon: icon
    }
  end
end
