# frozen_string_literal: true

##
# Representation of time spent at a place.
#
class PlaceScrobble < LocationScrobble
  CATEGORY_KLASS = PlaceCategory

  validate :singular_scrobbles_cannot_have_a_place

  delegate :place_match, to: :match_options
  delegate :attributes=, to: :match_options, prefix: true

  accepts_nested_attributes_for :place

  def friendly_type
    'Place'
  end

  def category_info
    place_id.present? ? category_klass.get(place.category) : super
  end

  def category_klass
    place.try(:service_id).present? ? Aux::PlaceCategory : super
  end

  def match_options
    @match_options ||= MatchOptions.new(self)
  end

  private

  def singular_scrobbles_cannot_have_a_place
    errors[:base] << 'Singular place scrobbles cannot have a place' if singular? && place_id.present?
  end
end
