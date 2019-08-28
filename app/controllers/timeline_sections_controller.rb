# frozen_string_literal: true

##
# CRUD for a user's timeline sections
#
class TimelineSectionsController < ApplicationController
  before_action :authenticate_user!

  def create
    @timeline = Timeline.for_user(current_user)

    flash[:danger] = 'An error occurred while adding that section' unless @timeline.add_section(section_params)

    redirect_back fallback_location: timeline_path
  end

  private

  def section_params
    params.require(:section).permit(:name, :scale)
  end
end
