# frozen_string_literal: true

##
# Base controller for {LocationScrobble}-related actions.
#
class LocationScrobblesController < AuthenticatedController
  include PlaceMatchable

  def index
    @from = params[:from] || Date.current.beginning_of_day
    @to = params[:to] || Date.current.end_of_day

    @location_scrobbles = current_user.location_scrobbles
      .overlapping_range(@from, @to)
      .order(start_time: :asc)
      .map(&:decorate)
  end

  def edit
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    find_place_match!(location_scrobble: @location_scrobble)

    @location_scrobble = @location_scrobble.decorate
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find(params[:id])

    if @location_scrobble.update(location_scrobble_params)
      process_place_match!(source: @location_scrobble.source, place: @location_scrobble.place)
    end

    @location_scrobble = @location_scrobble.decorate
  end

  private

  def location_scrobble_params
    params.require(:location_scrobble).permit(:place_id, :singular, :name)
  end
end
