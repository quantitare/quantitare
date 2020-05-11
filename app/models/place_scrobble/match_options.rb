# frozen_string_literal: true

class PlaceScrobble
  # Wrapper for accomodating nested attributes for {PlaceMatch}es on a given {PlaceScrobble}. Delegates most
  # "persistence" logic to the associated {PlaceMatch}, and decides whether it ought to create or update one when given
  # the +enabled+ flag. Takes care of copying all the fields from the associated scrobble to the {PlaceMatch}.
  #
  #   my_location_scrobble.assign_attributes(match_options_attributes: { enabled: true, match_name: true })
  #   my_location_scrobble.match_options.save
  #
  # Since this is not an ActiveRecord association, it must be saved separately. The service object
  # {ProcessPlaceMatchOptions} takes care of the business logic of handling form input.
  #
  class MatchOptions
    DEFAULT_RADIUS = 250

    attr_reader :place_scrobble, :to_delete, :enabled

    alias enabled? enabled
    alias to_delete? to_delete

    delegate :coordinates, to: :place_scrobble
    delegate :id, :source_field_radius, :source_field_radius=, :place, :place=, :save, :destroy, :valid?, :new_record?,
      :persisted?, :destroyed?,
      to: :place_match

    def initialize(place_scrobble)
      @place_scrobble = place_scrobble
    end

    def place_match
      @place_match ||= FindPlaceMatchForLocationScrobble.(place_scrobble) || new_place_match
    end

    def enabled=(value)
      @enabled = value.to_bool
    end

    def to_delete=(value)
      @to_delete = value.to_bool
    end

    def attributes=(attributes)
      attributes ||= {}

      self.enabled = attributes[:enabled]
      self.to_delete = attributes[:to_delete]

      self.match_name = attributes[:match_name]
      self.match_coordinates = attributes[:match_coordinates]

      self.source_field_radius = attributes[:source_field_radius]
    end

    def match_name
      place_match.source_field_name.present?
    end

    def match_name=(value)
      place_match.source_field_name = value.to_bool ? source_field_name : nil
    end

    def match_coordinates
      place_match.source_field_radius.present?
    end

    def match_coordinates=(value)
      if value.to_bool
        place_match.source_field_radius = DEFAULT_RADIUS
        place_match.source_field_latitude = source_field_latitude
        place_match.source_field_longitude = source_field_longitude
      else
        place_match.source_field_radius = nil
        place_match.source_field_latitude = nil
        place_match.source_field_longitude = nil
      end
    end

    def source_field_name
      place_scrobble.read_attribute(:name)
    end

    def source_field_latitude
      place_scrobble.latitude
    end

    def source_field_longitude
      place_scrobble.longitude
    end

    private

    def new_place_match
      PlaceMatch.new(
        user: place_scrobble.user,
        source: place_scrobble.source,
        place: place_scrobble.place
      )
    end
  end
end
