# frozen_string_literal: true

##
# A collection of general-purpose errors
#
module Errors
  ##
  # Raise a subclass of this when a problem occurs with an external service, such as an API outage or a misconfigured
  # configuration. Includes some metadata for reporting issues to the user.
  #
  class ServiceError < StandardError
    attr_reader :issue_reported, :nature

    # @param message [String] the error message
    # @param nature [#to_s] the nature of the issue to be reported
    # @param issue_reported [Boolean] true if an issue that caused this error has been reported, false otherwise
    def initialize(message = nil, nature: :general, issue_reported: false)
      super(message)

      @nature = nature
      @issue_reported = issue_reported
    end

    alias issue_reported? issue_reported
  end

  class ServiceAPIError < ServiceError; end
  class ServiceConfigError < ServiceError; end

  class ScrobbleBatchError < StandardError; end
end
