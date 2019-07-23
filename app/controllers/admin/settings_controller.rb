# frozen_string_literal: true

##
# Global settings are set here.
#
class Admin::SettingsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @settings = Setting.get_all
  end

  def update
    @setting_name = params[:id]
    @setting_value = params[:value]

    Setting[@setting_name] = @setting_value
  end
end
