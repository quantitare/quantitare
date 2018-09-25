# frozen_string_literal: true

##
# Handles the creation and subsequent
#
class ProcessPlaceMatch
  include Serviceable

  attr_reader :place_match, :options

  transactional!

  def initialize(place_match, options = {})
    @place_match = place_match
    @options = options
  end

  def call
    step :save_place_match
    step :process_existing_location_scrobbles
  end

  private

  def save_place_match
    place_match.save!
  end

  def process_existing_location_scrobbles
    place_match.matching_location_scrobbles.each do |location_scrobble|
      location_scrobble.update(place: place_match.place)
    end
  end
end
