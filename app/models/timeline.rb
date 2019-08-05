# frozen_string_literal: true

##
# A user's timeline, with selected modules.
#
class Timeline
  DEFAULT_SETTINGS = {
    day: {
      sections: [
        { name: 'Activity', modules: [{ component: 'device-activity' }] }
      ]
    },

    week: {
      sections: []
    },

    month: {
      sections: []
    },

    year: {
      sections: []
    }
  }.freeze

  class << self
    def for_user(user)
      new(user.settings.timeline)
    end
  end

  attr_reader :settings

  def initialize(settings)
    @settings = DEFAULT_SETTINGS.deep_merge(settings || {}) { |_key, this_val, other_val| this_val + other_val }
  end

  def to_h
    settings
  end
end
