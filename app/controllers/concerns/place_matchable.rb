# frozen_string_literal: true

##
# Adds helpers for dealing with {PlaceMatch} creation.
#
module PlaceMatchable
  extend ActiveSupport::Concern

  private

  def process_place_match!(source:, place:)
    return if params[:place_match].blank? || !params[:place_match][:enabled].to_bool

    @place_match = current_user.place_matches.new({ source: source, place: place }.merge(place_match_params))
    @place_match.save
  end

  def place_match_params
    params.require('place_match').permit(source_fields: [:name, :longitude, :latitude])
  end
end
