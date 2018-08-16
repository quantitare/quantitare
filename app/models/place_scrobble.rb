# frozen_string_literal: true

##
# Representation of time spent at a place.
#
class PlaceScrobble < LocationScrobble
  accepts_nested_attributes_for :place

  def friendly_type
    'Place'
  end
end
