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
  include Checkable
  include HasGuid
  include Intervalable
  include Oauthable
  include Optionable
  include Typeable

  has_many :scrobbles, as: :source, dependent: :destroy
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true

  scope :enabled, -> { where(disabled: false) }

  delegate :issues?, to: :service, allow_nil: true, prefix: true

  load_types_in 'Scrobblers'
  options_attribute :options

  def working?
    !service_issues?
  end

  def source_identifier
    "#{type}_#{id}"
  end

  def scrobbles_in_interval(from, to)
    scrobbles.overlapping_range(*denormalize_times(from, to))
  end

  def enabled
    !disabled
  end

  def enabled=(value)
    self.disabled = value
    self.disabled = !disabled
  end

  def enable!
    update!(disabled: false)
  end

  def disable!
    update!(disabled: true)
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
end
