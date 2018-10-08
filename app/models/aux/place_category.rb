# frozen_string_literal: true

module Aux
  ##
  # Lets the place metadata provider decide what kinds of categories it is going to use.
  #
  # == Data
  #
  # The +data+ attribute ought to have the following properties:
  #
  #   :name
  #   :plural_name
  #   :icon
  #
  # == Icons
  #
  # An icon has a +type+ attribute. At this time, there are two possible options: +'img'+ and +'fa'+.
  #
  # +img+ icons must have the following four extra attributes: +sm+, +md+, +lg+, and +xl+, each being a url to the
  # icon's 32-pixel, 44-pixel, 64-pixel, and 88-pixel variants, respectively.
  #
  # +fa+ icons must have a +name+ attribute pointing to the name of the icon being used.
  #
  class PlaceCategory < ServiceCache
    store_accessor :data, :icon, :name, :plural_name, :provider

    fetcher :id, [:id]

    class << self
      def default
        new(
          data: {
            id: nil,
            name: 'Place',
            plural_name: 'Places',
            icon: { type: 'fa', name: 'map-marker-alt' }
          }
        )
      end

      def get(identifier)
        fetch(adapter: Place.metadata_adapter, id: identifier)
      end
    end
  end
end
