# frozen_string_literal: true

##
# Representation of time spent at a place.
#
class PlaceScrobble < LocationScrobble
  CATEGORY_KLASS = PlaceCategory

  def friendly_type
    'Place'
  end

  def category_info
    place_id.present? ? category_klass.find(place.category) : super
  end
end
