# frozen_string_literal: true

##
# A data point for a given scrobbler.
#
class Scrobble < ApplicationRecord
  include HasGuid

  belongs_to :user
  belongs_to :source, polymorphic: true
end
