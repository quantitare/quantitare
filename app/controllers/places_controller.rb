# frozen_string_literal: true

##
# Handles requests related to {Place}s
#
class PlacesController < ApplicationController
  before_action :authenticate_user!

  def search
    # TODO: figure out a better API
    @custom_places = CustomPlaceAdapter.new.search_places(place_search_params.to_h.symbolize_keys)
      .available_to_user(current_user)
    @global_places = Place.search(place_search_params_with_adapter(Place.metadata_adapter))
  end

  def show
    @place = current_user.places.find(params[:id])
  end

  private

  def place_search_params
    params.permit(:longitude, :latitude)
  end

  def place_search_params_with_adapter(adapter)
    place_search_params.to_h.merge(adapter: adapter)
  end
end
