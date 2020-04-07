# frozen_string_literal: true

##
# LocationScrobble importers get called from here.
#
class LocationImportsController < ApplicationController
  before_action :authenticate_user!

  def new
    @location_import = current_user.location_imports.new
  end

  def create
    params[:location_import][:import_file].each do |file|
      location_import = current_user.location_imports.new(location_import_params.merge({ import_file: file }))
      result = ProcessLocationImport.(location_import, options_params)

      unless result.success?
        flash[:danger] = "Import aborted"

        break
      end
    end

    redirect_to new_location_import_path
  end

  def edit
  end

  private

  def location_import_params
    params.require(:location_import).permit(:adapter, :import_file)
  end

  def options_params
    params.require(:options).permit(:collision_mode)
  end
end
