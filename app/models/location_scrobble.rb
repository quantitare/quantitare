# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  belongs_to :place
  belongs_to :location_import

  class << self
    attr_accessor :importers
  end
end
