# frozen_string_literal: true

##
# Base controller for {LocationScrobble}-related actions.
#
class LocationScrobblesController < ApplicationController
  before_action :authenticate_user!

  include PlaceMatchable

  def index
    @from = params[:from] || Date.current.beginning_of_day
    @to = params[:to] || Date.current.end_of_day

    @location_scrobbles = current_user.location_scrobbles
      .overlapping_range(@from, @to)
      .order(start_time: :asc)
      .includes(place: :service)
      .map(&:decorate)
  end

  def edit
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    find_place_match!(location_scrobble: @location_scrobble)

    @location_scrobble = @location_scrobble.decorate
    @place_match = @place_match.decorate
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    if @location_scrobble.update(location_scrobble_params)
      find_place_match!(location_scrobble: @location_scrobble)
      process_place_match!(source: @location_scrobble.source, place: @location_scrobble.place)

      flash.now[:success] = 'Successfully updated!'
    else
      flash.now[:danger] = 'Something went wrong while trying to save this location scrobble'
    end

    @location_scrobble = @location_scrobble.decorate
    @place_match = @place_match.decorate
  end

  private

  def location_scrobble_params
    params.require(:location_scrobble).permit(:place_id, :singular, :name)
  end
end
