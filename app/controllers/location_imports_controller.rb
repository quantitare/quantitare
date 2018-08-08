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

    if @location_import.save
      redirect_to :edit
    else
      render :new
    end

    # parsed = importer.parse_import_file(file)
    # success = true

    # LocationScrobble.transaction do
    #   result = LocationScrobble.import(parsed.location_scrobbles)

    #   if result.failed_instances.present?
    #     success = false
    #     raise ActiveRecord::Rollback
    #   end
    # end

    # if success
    #   flash.success = 'Locations successfully imported!'
    #   redirect_to :show
    # else
    #   flash.danger = 'There was a problem importing your file.'
    #   redirect_to :back
    # end
  end

  def edit
  end

  private

  def location_import_params
    params.require(:location_import).permit(:adapter)
  end
end
