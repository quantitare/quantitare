# frozen_string_literal: true

##
# Stores credentials for an external service used to retrieve data from.
#
class Service < ApplicationRecord
  belongs_to :user, inverse_of: :services
  has_many :scrobblers, inverse_of: :service

  validates :user_id, presence: true
  validates :provider, presence: true
  validates :name, presence: true
  validates :token, presence: true

  class << self

  end
end
