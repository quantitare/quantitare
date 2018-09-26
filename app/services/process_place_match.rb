# frozen_string_literal: true

##
# Handles the creation and subsequent
#
class ProcessPlaceMatch
  include Serviceable

  attr_reader :place_match, :options

  def initialize(place_match, options = {})
    @place_match = place_match
    @options = options
  end

  def call
    step :save_place_match
    step :process_existing_location_scrobbles

    result.set(place_match: place_match)
  end

  private

  def save_place_match
    place_match.save!
  end

  def process_existing_location_scrobbles
    MatchLocationScrobblesToPlaceMatchJob.perform_later(place_match)
  end
end
