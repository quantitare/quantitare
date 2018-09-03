# frozen_string_literal: true

##
# A representation of a location scrobble. Separate from a normal scrobble, since the data represented is so vastly
# different from a typical scrobble.
#
class LocationScrobble < ApplicationRecord
  include Periodable

  belongs_to :user
  belongs_to :place, optional: true
  belongs_to :source, polymorphic: true

  default_scope -> { order(start_time: :asc) }

  def place?
    is_a? PlaceScrobble
  end

  def transit?
    is_a? TransitScrobble
  end

  def friendly_type
    raise NotImplementedError
  end
end
