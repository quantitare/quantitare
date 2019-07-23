# frozen_string_literal: true

##
# Retrieves type data for a scrobbler of a given type.
#
class Scrobblers::TypeDataController < ApplicationController
  before_action :authenticate_user!

  def show
    set_scrobbler!

    respond_to do |format|
      format.json
    end
  end

  private

  def set_scrobbler!
    @scrobbler =
      if params[:scrobbler_id].present?
        current_user.scrobblers.find(params[:scrobbler_id])
      else
        current_user.scrobblers.new(type: params[:type])
      end
  end
end
