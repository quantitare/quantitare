# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  @importers = [GoogleMapsKmlAdapter]

  belongs_to :place

  class << self
    attr_accessor :importers
  end
end
