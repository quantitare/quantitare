# frozen_string_literal: true

##
# Defines the workflow for creating a {LocationImport}
#
class ProcessLocationImport
  include Serviceable

  attr_reader :location_import, :options

  def initialize(location_import, options = {})
    @location_import = location_import
    @options = options.to_h.with_indifferent_access
  end

  def call
    step :save_location_import

    location_import.transaction do
      step :process_scrobbles
      step :save_location_import
    end

    result.set(location_import: location_import, options: options)
  end

  private

  # Steps

  def process_scrobbles
    scrobbles.each do |scrobble|
      location_import.location_scrobbles << scrobble
      scrobble.assign_attributes(user: location_import.user)

      result.errors += ProcessLocationScrobble.(scrobble, location_scrobble_processor_options).errors
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

  def location_scrobble_processor_options
    { save: false, collision_mode: options[:collision_mode] }
  end
end
