# frozen_string_literal: true

##
# Handles requests related to {Place}s
#
class PlacesController < AuthenticatedController
  def search
    @places = Place.available_to_user(current_user)
  end

  def show
    @place = current_user.places.find(params[:id])
  end

  def new
    @place = current_user.places.new.decorate
  end

  def create
    @location_scrobble = LocationScrobble.find_by(id: params[:location_scrobble_id]).try(:decorate)
    @place = current_user.places.new(place_params).decorate

    @place.location_scrobbles << @location_scrobble if @location_scrobble

    @place.save
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
end
