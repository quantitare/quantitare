# frozen_string_literal: true

##
# Base controller for {LocationScrobble}-related actions.
#
class LocationScrobblesController < AuthenticatedController
  def index
    @from = params[:from] || Date.current.beginning_of_day
    @to = params[:to] || Date.current.end_of_day

    @location_scrobbles = current_user.location_scrobbles.overlapping_range(@from, @to)
  end

  def edit
    @location_scrobble = current_user.location_scrobbles.find(params[:id]).decorate
  end

  def update
    @location_scrobble = current_user.location_scrobbles.find(params[:id]).decorate

    @location_scrobble.update(location_scrobble_params)
  end

  private

  def location_scrobble_params
    params.require(:location_scrobble).permit(:place_id, :singular)
  end
end
