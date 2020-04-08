# frozen_string_literal: true

module Aux
  ##
  # Caches a master list of a given provider's place category data.
  #
  class PlaceCategoryList < ServiceCache
    store_accessor :data, :categories

    fetcher :provider, [:provider]
  end
end
