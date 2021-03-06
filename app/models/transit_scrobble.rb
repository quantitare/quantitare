# frozen_string_literal: true

##
# A representation of when a user is traveling, whether by foot, car, bike, or whatever.
#
class TransitScrobble < LocationScrobble
  CATEGORY_KLASS = TransitCategory

  validate :cannot_be_singular

  def friendly_type
    'Transit'
  end

  private

  def cannot_be_singular
    errors[:singular] << 'cannot be true for transit scrobbles' if singular?
  end
end
