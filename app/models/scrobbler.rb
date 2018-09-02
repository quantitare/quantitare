# frozen_string_literal: true

##
# A Scrobbler is an object that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
class Scrobbler < ActiveRecord::Base
  include HasGuid
  include Typeable
  include Oauthable

  has_many :scrobbles, as: :source
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true

  load_types_in 'Scrobblers'
end
