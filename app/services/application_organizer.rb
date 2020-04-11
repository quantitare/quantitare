# frozen_string_literal: true

##
# Application-specific abstractions for a +LightService+ organizer.
#
module ApplicationOrganizer
  extend ActiveSupport::Concern

  included do
    extend LightService::Organizer
  end

  class_methods do
    # @see ApplicationOrganizer::WithTransaction
    def with_transaction(steps)
      WithTransaction.run(self, steps)
    end
  end
end
