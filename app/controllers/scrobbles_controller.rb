# frozen_string_literal: true

##
# = Scrobbles controller
#
class ScrobblesController < ApplicationController
  include TimelineScalable

  before_action :authenticate_user!

  def index
    @scrobbles = Scrobbles::ForTimelineQuery.(current_user.scrobbles, scale: scale, date: date, categories: categories)
    @location_scrobbles = LocationScrobbles::ForTimelineQuery.(
      current_user.location_scrobbles, scale: scale, date: date
    )
  end
end
