# frozen_string_literal: true

##
# Handles requests related to {Place}s
#
class PlacesController < AuthenticatedController
  include PlaceMatchable

  def search
    # @places = Place.available_to_user(current_user)
    @places = Place.search(place_search_params.to_h.merge(adapter: Place.metadata_adapter))
  end

  def show
    @place = current_user.places.find(params[:id])
  end

  def new
    @place = current_user.places.new.decorate
  end

  def create
    @location_scrobble = current_user.location_scrobbles.find_by(id: params[:location_scrobble_id]).try(:decorate)
    @place = current_user.places.new(place_params).decorate

    @place.location_scrobbles << @location_scrobble if @location_scrobble

    process_place_match!(source: @location_scrobble.source, place: @place) if @place.save && @location_scrobble.present?
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find_by(id: params[:location_scrobble_id]).try(:decorate)
    @place = current_user.places.find(params[:id]).decorate

    @place.update(place_params)
  end

  private

  def place_params
    params.require(:place).permit(
      :name, :category,
      :street_1, :street_2, :city, :state, :zip, :country,
      :latitude, :longitude,
      :global
    )
  end

  def place_search_params
    params.permit(:longitude, :latitude)
  end
end
