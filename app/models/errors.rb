# frozen_string_literal: true

##
# A collection of general-purpose errors
#
module Errors
  ##
  # Raise a subclass of this when a problem occurs with an external service, such as an API outage or a misconfigured
  # configuration.
  #
  class ServiceError < StandardError
    attr_reader :issue_reported, :nature

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
