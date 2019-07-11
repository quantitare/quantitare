# frozen_string_literal: true

##
# A Scrobbler is an entity that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
# == Class attributes
#
# - +fetches_in_chunks+: A boolean value that determines how the scrobble-fetch engine should divide up the given
#   interval. If this is set to +true+, then it will divide the interval up into portions based on the
#   +request_chunk_size+ value. If +false+, then it will attempt to fetch scrobbles for the entire interval, regardless
#   of how large it is. It is generally a good idea to enable this to prevent issues when dealing with larger sets of
#   data. The {.fetches_in_chunks!} macro can be used to set this to +true+.
# - +request_chunk_size+: An +ActiveSupport::Duration+ object that determines how large the chunks should be when
#   fetching larger intervals of time. This will wholly depend on the service and the nature of the data, but the
#   default is set to 7 days.
# - +request_cadence+: An +ActiveSupport::Duration+ object that determines how long to wait between fetches before
#   fetching the next batch of data. Use this value to reduce the likelihood of being rate limited. The default value
#   is 0 seconds.
# - +interval_batch_scale+: A symbol that determines at which scale the service is expecting the timestamps to be in.
#   While many services will accept time values, some only support dates. If this is the case, set this value to
#   +:date+, and the fetching engine will divide chunks and pass values to {#fetch_scrobbles} accordingly. This
#   functionality comes from the {Intervalable} concern.
# - +interval_start_inclusive+ and +interval_end_inclusive+: These are boolean that are meant to echo how the service
#   treats the time intervals that it is passed. By default, these are both set to true, but if the service excludes
#   either of these bounds, you may set it accordingly. This functionality comes from the {Intervalable} concern.
#
class Scrobbler < ApplicationRecord
  include HasGuid
  include Intervalable
  include Oauthable
  include Optionable
  include Schedulable
  include Typeable

  has_many :scrobbles, as: :source, dependent: :destroy
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true

  scope :enabled, -> { where(disabled: false) }

  class_attribute :fetches_in_chunks, instance_writer: false, default: false
  class_attribute :request_chunk_size, instance_writer: false, default: 7.days
  class_attribute :request_cadence, instance_writer: false, default: 0.seconds

  delegate :issues?, to: :service, allow_nil: true, prefix: true

  load_types_in 'Scrobblers'
  options_attribute :options

  class << self
    def fetches_in_chunks!
      self.fetches_in_chunks = true
    end
  end

  def source_identifier
    "#{type}_#{id}"
  end

  def scrobbles_in_interval(from, to)
    scrobbles.overlapping_range(*denormalize_times(from, to))
  end

  def enable!
    update!(disabled: false)
  end

  def disable!
    update!(disabled: true)
  end

  def run_check(check, &handler)
    range = range_for_check(check)
    fetches_in_chunks? ? collect_scrobbles_in_chunks(*range, &handler) : collect_scrobbles(*range, &handler)
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
        [fetch_and_format_scrobbles(start_time, end_time), nil]
      rescue Errors::ServiceError => e
        [[], e]
      end

    batch = ScrobbleBatch.new(scrobbles, source: self, start_time: start_time, end_time: end_time, error: error)

    yield(batch) if block_given?

    batch
  end

  def fetch_and_format_scrobbles(start_time, end_time)
    start_time, end_time = normalize_times(start_time, end_time)

    scrobbles = fetch_scrobbles(start_time, end_time)

    scrobbles.map { |scrobble| build_scrobble(scrobble) }
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
  # @param start_time [Time, Date] the beginning of the time range from which to fetch data
  # @param end_time [Time, Date] the end of the time rante from which to fetch data
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
