# frozen_string_literal: true

##
# Saves a GUID on the model if there is none present. Model must have a +guid+ attribute.
#
module HasGuid
  extend ActiveSupport::Concern

  included do
    attribute :guid, :string, default: -> { SecureRandom.uuid }
  end
end
