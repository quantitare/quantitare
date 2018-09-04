# frozen_string_literal: true

##
# Saves a GUID on the model if there is none present. Model must have a +guid+ attribute.
#
module HasGuid
  extend ActiveSupport::Concern

  included do
    before_save :generate_guid
  end

  protected

  def generate_guid
    self.guid = SecureRandom.uuid if guid.blank?
  end
end
