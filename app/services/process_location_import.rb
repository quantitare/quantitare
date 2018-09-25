# frozen_string_literal: true

##
# Defines the workflow for creating a {LocationImport}
#
class ProcessLocationImport
  include Serviceable

  attr_reader :location_import, :options

  transactional!

  def initialize(location_import, options = {})
    @location_import = location_import
    @options = options
  end

  def call
    step :process_scrobbles
    step :save_location_import

    result.set(location_import: location_import, options: options)
  end

  private

  # Steps

  def process_scrobbles
    scrobbles.each do |scrobble|
      location_import.location_scrobbles << scrobble
      scrobble.assign_attributes(user: location_import.user)

      result.errors += ProcessLocationScrobble.(scrobble, save: false).errors
    end
  end

  def save_location_import
    result.errors += location_import.errors.full_messages unless location_import.save
  end

  # Helpers

  def scrobbles
    @scrobbles ||= adapter.location_scrobbles
  end

  def adapter
    location_import.prepared_adapter
  end

  def process_import_result(import_result)
    result.errors << 'There was a problem importing the file you uploaded' if import_result.failed_instances.present?
  end
end
