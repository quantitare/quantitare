# frozen_string_literal: true

##
# Defines the workflow for creating a new {LocationScrobble}
#
class ProcessLocationScrobble
  include Serviceable

  DEFAULT_OPTIONS = { save: true }.freeze

  attr_reader :location_scrobble, :options

  transactional!

  def initialize(location_scrobble, options = {})
    @location_scrobble = location_scrobble
    @options = options.reverse_merge(DEFAULT_OPTIONS)
  end

  def call
    step(:match_place)
    step(:save_scrobble)

    result.set(location_scrobble: location_scrobble, options: options)
  end

  private

  def match_place
    return unless location_scrobble.place?

    # TODO
  end

  def save_scrobble
    return unless options[:save]

    result.errors += location_scrobble.errors.full_messages unless location_scrobble.save
  end
end
