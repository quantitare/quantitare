# frozen_string_literal: true

##
# Base controller for {LocationScrobble}-related actions.
#
class LocationScrobblesController < ApplicationController
  include PlaceMatchable

  respond_to :geojson, only: :index
  respond_to :js, only: :update

  before_action :authenticate_user!

  def index
    @from = Time.zone.parse(params[:from]) || Date.current.beginning_of_day
    @to = Time.zone.parse(params[:to]) || Date.current.end_of_day

    set_location_scrobbles_collection!
  end

  def edit
    @location_scrobble = current_user.location_scrobbles.find(params[:id])
    @location_scrobble.place = current_user.places.build(place_params_from_scrobble) if initialize_place?

    find_place_match!(location_scrobble: @location_scrobble)

    @location_scrobble = @location_scrobble.decorate
    @place_match = @place_match.decorate
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    if @location_scrobble.update(location_scrobble_params)
      find_place_match!(location_scrobble: @location_scrobble)
      process_place_match!(source: @location_scrobble.source, place: @location_scrobble.place)
    end

    @location_scrobble = @location_scrobble.decorate
    @place_match = @place_match.decorate

    respond_with @location_scrobble
  end

  private

  def set_location_scrobbles_collection!
    @location_scrobbles =
      current_user.location_scrobbles
        .overlapping_range(@from, @to)
        .order(start_time: :asc)
        .includes(place: :service)

    @location_scrobbles = @location_scrobbles.place if params[:type] == 'place'
    @location_scrobbles = @location_scrobbles.transit if params[:type] == 'transit'

    @location_scrobbles = @location_scrobbles.map(&:decorate)
  end

  def location_scrobble_params
    params.require(:location_scrobble).permit(:place_id, :singular, :name)
  end

  def place_params_from_scrobble
    { name: @location_scrobble.name }
  end

  def initialize_place?
    @location_scrobble.place? && @location_scrobble.place.blank?
  end
end
