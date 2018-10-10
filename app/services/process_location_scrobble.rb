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

  transactional!

  def initialize(location_scrobble, options = {})
    @location_scrobble = location_scrobble
    @options = options.with_indifferent_access.reverse_merge(DEFAULT_OPTIONS)
  end

  def call
    step :save_scrobble
    step :match_place

    result.set(location_scrobble: location_scrobble, options: options)
  end

  private

  def save_scrobble
    # TODO: set an option for this overwrite logic
    LocationScrobble.overlapping_range(location_scrobble.start_time, location_scrobble.end_time).destroy_all

    options[:save] ? location_scrobble.save : location_scrobble.validate

    result.errors += location_scrobble.errors.full_messages
  end

  def match_place
    return unless location_scrobble.place?

    match_result = options[:matcher].(location_scrobble, save: options[:save])

    result.errors += match_result.errors
  end
end
