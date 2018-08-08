# frozen_string_literal: true

##
# Walks through the supplemental processes involved with {LocationImport} creation
#
class ProcessLocationImport
  extend Memoist
  include Serviceable

  attr_reader :location_import, :options

  transactional!

  def initialize(location_import, options = {})
    @location_import = location_import
    @options = options
  end

  def call
    step(:save_location_import)
    step(:create_scrobbles)

    result.set(location_import: location_import, options: options)
  end

  private

  def save_location_import
    result.errors << location.errors.full_messages unless location_import.save
  end

  def create_scrobbles
    scrobbles = prepare_location_scrobbles
    import_result = LocationScrobble.import(scrobbles, validate: true)
    process_import_result(import_result)
  end

  def prepare_location_scrobbles
    scrobbles = adapter.location_scrobbles

    scrobbles.each do |scrobble|
      scrobble.assign_attributes(source: location_import, user: location_import.user)
      scrobble.run_callbacks(:save) { false }
    end

    scrobbles
  end

  def adapter
    location_import.prepared_adapter
  end

  def process_import_result(import_result)
    result.errors << 'There was a problem importing the file you uploaded' if import_result.failed_instances.present?
  end
end
