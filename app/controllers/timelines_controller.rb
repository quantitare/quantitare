# frozen_string_literal: true

##
# Endpoint for displaying the user's timeline
#
class TimelinesController < ApplicationController
  include TimelineScalable

  before_action :authenticate_user!

  def show
    @settings = Timeline.for_user(current_user).to_h[scale.to_sym].with_indifferent_access
  end
end
