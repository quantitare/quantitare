# frozen_string_literal: true

##
# A representation of when a user is traveling, whether by foot, car, bike, or whatever.
#
class TransitScrobble < LocationScrobble
  def friendly_type
    'Transit'
  end
end
