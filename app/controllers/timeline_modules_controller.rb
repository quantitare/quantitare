# frozen_string_literal: true

##
# Returns data for selected timeline modules at a given scale/date combination
#
class TimelineModulesController < ApplicationController
  include TimelineScalable

  before_action :authenticate_user!

  def show
    @module = current_user.timeline_modules.find(params[:id])
    @assimilator = TimelineModule::Assimilator.new(@module, scale, date)
  end
end
