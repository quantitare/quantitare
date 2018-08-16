# frozen_string_literal: true

##
# A place
#
class Place < ApplicationRecord
  include HasGuid

  has_many :location_scrobbles
  belongs_to :user, optional: true
end
