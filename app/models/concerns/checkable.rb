# frozen_string_literal: true

##
# Provides macros and wrapper functions for running a check for {Scrobble}s on a given schedule.
#
module Checkable
  extend ActiveSupport::Concern

  included do
    include Schedulable

    class_attribute :fetches_in_chunks, instance_writer: false, default: false
    class_attribute :request_chunk_size, instance_writer: false, default: 7.days
    class_attribute :request_cadence, instance_writer: false, default: 0.seconds
  end

  class_methods do
    def fetches_in_chunks!
      self.fetches_in_chunks = true
    end
  end

  def run_check(check, &handler)
    range = range_for_check(check)
    fetches_in_chunks? ? collect_scrobbles_in_chunks(*range, &handler) : collect_scrobbles(*range, &handler)
  end

  def collect_scrobbles_in_chunks(start_time, end_time, &handler)
    chunks_for_times(start_time, end_time).each do |chunk_start, chunk_end|
      collect_scrobbles(chunk_start, chunk_end, &handler)

      sleep request_cadence
    end
  end

  # Fetches scrobbles from the service between the +start_time+ and +end_time+, handling the expected errors by storing
  # them in the returned object. Yields to the block to handle the batch if given.
  #
  #   scrobbler.collect_scrobbles(2.hours.ago, Time.current) { |batch| puts 'yay' if batch.success? }
  #
  # @param start_time [Time] the beginning of the time range from which to fetch data
  # @param end_time [Time] the end of the time rante from which to fetch data
  # @return [ScrobbleBatch] the list of scrobbles fetched from the service, with additional metadata
  # @yield [batch] provides an interface for handling the generated batch of scrobbles. Useful for collecting multiple
  #   batches from a service
  def collect_scrobbles(start_time, end_time)
    scrobbles, error =
      begin
        [fetch_and_format_scrobbles(start_time, end_time), nil]
      rescue Errors::ServiceError => e
        [[], e]
      end

    batch = ScrobbleBatch.new(scrobbles, source: self, start_time: start_time, end_time: end_time, error: error)

    yield(batch) if block_given?

    batch
  end

  private

  def chunks_for_times(start_time, end_time)
    start_time, end_time = normalize_times(start_time, end_time)
    base_time = end_time - request_chunk_size
    chunks = []

    loop do
      chunk_start = [base_time, start_time].max
      chunk_end = [chunk_start + request_chunk_size, base_time + request_chunk_size].min
      chunks << [chunk_start, chunk_end]

      break if base_time <= start_time

      base_time -= request_chunk_size
    end

    chunks
  end
end
