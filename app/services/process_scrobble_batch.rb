# frozen_string_literal: true

##
# Defines the process for
#
class ProcessScrobbleBatch
  include Serviceable

  delegate :source, :start_time, :end_time, to: :batch

  transactional!

  attr_reader :batch

  def initialize(batch)
    @batch = batch
  end

  def call
    step :check_for_batch_errors
    step :validate_batch
    step :clean_up_existing_scrobbles
    step :prepare_import
    step :import_batch
    step :update_counter_cache

    result.set batch: batch, source: source
  end

  private

  # Aux

  def sources
    batch.map(&:source)
  end

  # Steps

  def check_for_batch_errors
    result.errors << 'batch contained errors' unless batch.success?
  end

  def validate_batch
    result.errors << 'batch contained invalid scrobbles' unless batch.all?(&:valid?)
    result.errors << 'all scrobbles must belong to the same source' if sources.uniq.length > 1
  end

  def clean_up_existing_scrobbles
    source.scrobbles.overlapping_range(start_time, end_time).destroy_all
  end

  def prepare_import
    batch.each { |scrobble| scrobble.run_callbacks(:save) { false } }
  end

  def import_batch
    import = Scrobble.import batch.scrobbles, validate: false

    result.set import_data: import
    result.errors << "import failed for #{import.failed_instances.size} scrobbles" if import.failed_instances.present?
  end

  def update_counter_cache
    update_success = source.update scrobbles_count: source.scrobbles.count

    result.errors << 'could not update scrobble counts' unless update_success
  end
end
