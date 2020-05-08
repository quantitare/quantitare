# frozen_string_literal: true

##
# Base controller for {LocationScrobble}-related actions.
#
class LocationScrobblesController < ApplicationController
  respond_to :geojson, only: [:index, :show]
  respond_to :js, only: :update

  before_action :authenticate_user!

  layout false, only: [:show]

  def index
    @from = Time.zone.parse(params[:from]) || Date.current.beginning_of_day
    @to = Time.zone.parse(params[:to]) || Date.current.end_of_day

    set_location_scrobbles_collection!
  end

  def show
    @location_scrobble = current_user.location_scrobbles.find(params[:id])
    @fresh_place = current_user.places.build(place_params_from_scrobble) if @location_scrobble.place?

    @location_scrobble = @location_scrobble.decorate

    render layout: 'modal_content'
  end

  def edit
    @location_scrobble = current_user.location_scrobbles.find(params[:id])
    @fresh_place = current_user.places.build(place_params_from_scrobble) if @location_scrobble.place?

    @location_scrobble = @location_scrobble.decorate
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    UpdateLocationScrobble.(location_scrobble: @location_scrobble, params: location_scrobble_params, save: true)

    @location_scrobble = @location_scrobble.decorate

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
    params.require(:location_scrobble)
      .permit(
        :place_id, :singular, :name,

        place_attributes: [
          :id, :name, :category, :global,
          :street_1, :street_2, :city, :state, :zip, :country,
          :longitude, :latitude
        ],

        match_options_attributes: [
          :enabled, :match_name, :match_coordinates,
          :source_field_radius
        ]
      )
  end

  def place_params_from_scrobble
    { name: @location_scrobble.name, latitude: @location_scrobble.latitude, longitude: @location_scrobble.longitude }
  end
end
