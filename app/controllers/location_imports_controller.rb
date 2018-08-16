# frozen_string_literal: true

##
# LocationScrobble importers get called from here.
#
class LocationImportsController < AuthenticatedController
  def new
    @location_import = current_user.location_imports.new
  end

  def create
    @location_import = current_user.location_imports.new(location_import_params)
    @location_import.import_file.attach(params[:location_import][:import_file])

    @result = ProcessLocationImport.(@location_import)

    if @result.success?
      redirect_to locations_path(from: @location_import.interval[0], to: @location_import.interval[1])
    else
      render :new
    end
  end

  def edit
  end

  private

  def location_import_params
    params.require(:location_import).permit(:adapter)
  end
end
