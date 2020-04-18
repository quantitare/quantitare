# frozen_string_literal: true

##
# A user's timeline, with selected modules.
#
class Timeline
  DEFAULT_SETTINGS = {
    day: { sections: [] },
    week: { sections: [] },
    month: { sections: [] },
    year: { sections: [] }
  }.freeze

  SECTION_SCHEMA = Dry::Schema.Params do
    required(:id).filled(:string)
    required(:name).filled(:string)
    required(:scale).value(included_in?: DEFAULT_SETTINGS.keys.map(&:to_s))
  end

  class << self
    alias for_user new

    def scales
      DEFAULT_SETTINGS.keys
    end
  end

  attr_reader :user

  delegate :scales, to: :class

  def initialize(user)
    @user = user
  end

  def settings
    @settings ||= (user.settings.timeline || {}).reverse_merge(DEFAULT_SETTINGS)
  end

  def to_h
    settings.keys.index_with { |scale| { sections: full_sections_for_scale(scale) } }
  end

  def add_section(params)
    params = params.reverse_merge(default_section_params).to_h.with_indifferent_access
    scale = params[:scale].to_sym

    return false unless validate_section(params)

    settings[scale][:sections] << params
    save_settings
  end

  def validate_section(params)
    SECTION_SCHEMA.(params).success?
  end

  def save_settings
    user.settings.timeline = settings
  end

  private

  def default_section_params
    { id: SecureRandom.uuid }
  end

  def full_sections_for_scale(scale)
    settings[scale][:sections].map do |section|
      section.merge('modules' => timeline_modules_for_section(section).map(&:to_h))
    end
  end

  def timeline_modules_for_section(section)
    (timeline_module_groups[section['id']] || []).sort_by(&:rank)
  end

  def timeline_module_groups
    @timeline_module_groups ||= user.timeline_modules.group_by(&:section)
  end
end
