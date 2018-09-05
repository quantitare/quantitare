# frozen_string_literal: true

##
# A place
#
class Place < ApplicationRecord
  include HasGuid

  has_many :location_scrobbles, dependent: :nullify
  belongs_to :user, optional: true

  scope :available_to_user, ->(user) { where(global: true).or(where(user: user)) }
end
