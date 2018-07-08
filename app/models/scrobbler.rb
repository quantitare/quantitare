# frozen_string_literal: true

##
# A Scrobbler is an object that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
class Scrobbler < ActiveRecord::Base
  include HasGuid

  belongs_to :user
  belongs_to :service
  has_many :scrobbles, inverse_of: :scrobbler
end
