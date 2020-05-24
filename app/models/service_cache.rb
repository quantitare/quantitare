# frozen_string_literal: true

##
# Cached data for a {Service}. Used to prevent repetitive API calls to a given service.
#
class ServiceCache < ApplicationRecord
  include ServiceFetchable
  include AttrJson::Record
  include AttributeAnnotatable

  EXPIRY_INTERVAL = 1.month.freeze

  attr_json_config default_container_attribute: :data

  belongs_to :service, optional: true

  acts_as_taggable

  delegate :user, to: :service, allow_nil: true
end
