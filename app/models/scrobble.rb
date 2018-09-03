# frozen_string_literal: true

##
# A data point for a given scrobbler.
#
class Scrobble < ApplicationRecord
  include HasGuid
  include Periodable

  belongs_to :user
  belongs_to :source, polymorphic: true, counter_cache: true

  validates :category, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
