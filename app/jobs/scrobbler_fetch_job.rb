# frozen_string_literal: true

##
# Fetches scrobbles from a scrobbler and processes them. Makes a direct call to the {Scrobbler#fetch_scrobbles} method
# in order to handle errors directly. Meant as a way to
#
class ScrobblerFetchJob < ApplicationJob
  queue_as :fetch

  discard_on(Errors::ServiceConfigError) do |job, error|
    unless error.issue_reported || job.service.blank?
      job.service.report_issue! :general, <<~TEXT.squish
        An issue was found with this service. Please verify that the credentials you are using to authenticate with it
        are correct.
      TEXT
    end
  end

  delegate :service, to: :scrobbler

  attr_accessor :scrobbler

  # @param scrobble [Scrobbler] the scrobbler whose scrobbles are to be fetched
  # @param start_time [Integer, Time] the beginning of the range of time from which to fetch scrobbles
  # @param end_time [Integer, Time] the end of the range of time from which to fetch scrobbles
  # @param processor [#call] the processor being used to process the resulting batch of scrobbles
  # @raise [Errors::ScrobbleBatchError] if the returned batch was not able to be processed
  def perform(scrobbler, start_time, end_time, processor: ProcessScrobbleBatch)
    self.scrobbler = scrobbler
    start_time = Time.zone.at(start_time)
    end_time = Time.zone.at(end_time)

    scrobbles = scrobbler.fetch_scrobbles(start_time, end_time)
    batch = ScrobbleBatch.new(scrobbles: scrobbles, start_time: start_time, end_time: end_time)
    result = processor.(batch)

    raise Errors::ScrobbleBatchError, result.errors.join(', ') unless result.success?
  end
end
