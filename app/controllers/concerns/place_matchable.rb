# frozen_string_literal: true

##
# Adds helpers for dealing with {PlaceMatch} creation and processing.
#
module PlaceMatchable
  extend ActiveSupport::Concern

  private

  def find_place_match!(location_scrobble:)
    @place_match =
      FindPlaceMatchForLocationScrobble.(location_scrobble) ||
      current_user.place_matches.build(source: location_scrobble.source)
  end

  def process_place_match!(source:, place:)
    return unless place_match_ready?

    @place_match ||= current_user.place_matches.new(source: source)
    @place_match.assign_attributes({ place: place }.merge(place_match_params))

    ProcessPlaceMatch.(@place_match)
  end

  def place_match_ready?
    params[:place_match].present? &&
      (params[:place_match][:enabled].to_bool || params[:place_match][:to_delete].to_bool)
  end

  def place_match_params
    params.require('place_match').permit(:enabled, :to_delete, source_fields: [:name, :longitude, :latitude])
  end
end
