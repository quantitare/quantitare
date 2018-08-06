# frozen_string_literal: true

##
# LocationScrobble importers get called from here.
#
class LocationImportsController < AuthenticatedController
  def show
  end

  def new
    @location_import = LocationImport.new
  end

  def create
    file = File.read(params[:file].tempfile)
    importer = Object.const_get(params[:importer])

    parsed = importer.parse_import_file(file)
    success = true

    LocationScrobble.transaction do
      result = LocationScrobble.import(parsed.location_scrobbles)

      if result.failed_instances.present?
        success = false
        raise ActiveRecord::Rollback
      end
    end

    if success
      flash.success = 'Locations successfully imported!'
      redirect_to :show
    else
      flash.danger = 'There was a problem importing your file.'
      redirect_to :back
    end
  end
end
