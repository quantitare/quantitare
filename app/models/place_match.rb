# frozen_string_literal: true

##
# Stores data for "place matches" which allows us to match apply place changes to {LocationScrobble}s with similar
# characteristics.
#
class PlaceMatch < ApplicationRecord
  belongs_to :user
  belongs_to :source, polymorphic: true
  belongs_to :place

  serialize :source_fields, HashSerializer
end
