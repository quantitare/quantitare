# frozen_string_literal: true

##
# Wrapper for a location scrobble's category information.
#
class LocationCategory
  class << self
    def all
      all_hash.values
    end

    def get(name)
      all_hash[name]
    end

    def default
      new('')
    end

    def default_icon
      const_get('DEFAULT_ICON')
    end

    private

    def all_hash
      Hash[
        YAML.load_file(data_path).map do |category_hash|
          [category_hash['name'], new(category_hash['name'], category_hash['icon'] || default_icon)]
        end
      ]
    end

    def data_path
      const_get('DATA_PATH')
    end
  end

  attr_reader :name, :icon

  def initialize(name, icon = self.class.default_icon)
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
