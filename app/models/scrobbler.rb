# frozen_string_literal: true

##
# A Scrobbler is an object that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
class Scrobbler < ApplicationRecord
  include HasGuid
  include Typeable
  include Oauthable
  include Optionable
  include Schedulable

  has_many :scrobbles, as: :source, dependent: :destroy
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true

  class_attribute :fetch_in_chunks, instance_writer: false, default: false
  class_attribute :request_cadence, instance_writer: false, default: 0.seconds
  class_attribute :request_chunk_size, instance_writer: false, default: 1.week

  delegate :issues?, to: :service, allow_nil: true, prefix: true

  load_types_in 'Scrobblers'
  options_attribute :options

  class << self
    def fetch_in_chunks!
      self.fetch_in_chunks = true
    end
  end

  def source_identifier
    "#{type}_#{id}"
  end

  def run_check(check, &handler)
    range = range_for_check(check)
    fetch_in_chunks? ? collect_scrobbles_in_chunks(*range, &handler) : collect_scrobbles(*range, &handler)
  end

  def collect_scrobbles_in_chunks(start_time, end_time, &handler)
    chunks_for_times(start_time, end_time).each do |chunk_start, chunk_end|
      collect_scrobbles(chunk_start, chunk_end, &handler)
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
        [fetch_scrobbles(start_time, end_time), nil]
      rescue Errors::ServiceError => e
        [[], e]
      end

    batch = ScrobbleBatch.new(scrobbles, source: self, start_time: start_time, end_time: end_time, error: error)

    yield(batch) if block_given?

    batch
  end

  # Implement this in a subclass. This is the entrypoint through which the scrobbler will generate new scrobbles. The
  # conventions listed in this doc describe how the method is expected to behave.
  #
  #   def fetch_scrobbles(start_time, end_time)
  #     result = adapter.fetch_scrobbles(start_time, end_time)
  #
  #     case result.status
  #     when 400..499
  #       raise Errors::ServiceConfigError, 'There was a problem with your service', nature: :provider_credentials
  #     when 500..599
  #       raise Errors::ServiceAPIError
  #     else
  #       result.scrobbles
  #     end
  #   end
  #
  # @param start_time [Time] the beginning of the time range from which to fetch data
  # @param end_time [Time] the end of the time rante from which to fetch data
  # @return [Array<Scrobble>] a list of new, unsaved scrobble instances
  # @raise [Errors::ServiceAPIError] if the service is experiencing temporary issues, such as rate limits or and API
  #   outage
  # @raise [Errors::ServiceConfigError] if there is an issue with the service's configuration, such as invalid
  #   authentication credentials
  # @raise [NotImplementedError] if the subclass has not implemented this method
  def fetch_scrobbles(_start_time, _end_time)
    raise NotImplementedError
  end

  def create_scrobble(scrobble)
    scrobble = build_scrobble(scrobble)
    scrobble.save!

    scrobble
  end

  def build_scrobble(scrobble)
    scrobble =
      if scrobble.is_a?(Hash)
        scrobbles.build(scrobble)
      else
        scrobble.source = self
        scrobble
      end

    scrobble.user = user

    scrobble
  end

  def handle_webhook(_request)
    WebResponse.new(content: 'not implemented', status: 404)
  end

  private

  def chunks_for_times(start_time, end_time)
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
