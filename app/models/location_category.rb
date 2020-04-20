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
      YAML.load_file(data_path).map do |category_hash|
        [
          category_hash['name'],
          new(category_hash['name'], category_hash['icon'] || default_icon, colors: category_hash['colors'] || {})
        ]
      end.to_h
    end

    def data_path
      const_get('DATA_PATH')
    end
  end

  attr_reader :name, :colors

  def initialize(name, icon: self.class.default_icon, colors: {})
    @name = name
    @icon = icon
    @colors = colors
  end

  def icon
    @icon.is_a?(Hash) ? parse_icon : @icon
  end

  def to_h
    {
      name: name,
      icon: icon.to_h,
      colors: colors
    }
  end

  private

  def parse_icon
    icon_options = @icon.deep_dup.deep_symbolize_keys

    Icon.for(icon_options.delete(:type), icon_options)
  end
end
