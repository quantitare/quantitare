# frozen_string_literal: true

##
# Rep
#
class LocationCategory
  class << self
    def all
      [new('foo')]
    end
  end

  attr_reader :name, :icon

  def initialize(name, icon = 'map-marker-alt')
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
