# frozen_string_literal: true

##
# A Scrobbler is an object that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
class Scrobbler < ApplicationRecord
  include HasGuid
  include Typeable
  include Oauthable
  include Optionable

  has_many :scrobbles, as: :source, dependent: :destroy
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true

  load_types_in 'Scrobblers'
  options_attribute :options

  def source_identifier
    "#{type}_#{id}"
  end
end
