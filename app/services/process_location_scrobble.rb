# frozen_string_literal: true

##
# Defines the workflow for creating a new {LocationScrobble}
#
class ProcessLocationScrobble
  include Serviceable

  DEFAULT_OPTIONS = {
    save: true,
    matcher: MatchPlaceToLocationScrobble
  }.with_indifferent_access.freeze

  attr_reader :location_scrobble, :options
  attr_accessor :skip

  transactional!

  def initialize(location_scrobble, options = {})
    @location_scrobble = location_scrobble
    @options = options.to_h.with_indifferent_access.reverse_merge(DEFAULT_OPTIONS)
  end

  alias skip? skip

  def call
    step :handle_collisions
    step :save_scrobble
    step :match_place

    result.set(location_scrobble: location_scrobble, options: options)
  end

  private

  def handle_collisions
    case options[:collision_mode].try(:to_sym)
    when :overwrite
      location_scrobble.user.location_scrobbles
        .overlapping_range(location_scrobble.start_time, location_scrobble.end_time)
        .destroy_all
    when :skip
      self.skip = true
    end
  end

  def save_scrobble
    return if skip?

    options[:save] ? location_scrobble.save : location_scrobble.validate

    result.errors += location_scrobble.errors.full_messages
  end

  def match_place
    return if skip?
    return unless location_scrobble.place?

    match_result = options[:matcher].(location_scrobble, save: options[:save])

    result.errors += match_result.errors
  end
end
