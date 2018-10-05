# frozen_string_literal: true

require_dependency 'service_cache'

module Aux
  ##
  # Caches a master list of a given provider's place category data.
  #
  class PlaceCategoryList < ServiceCache
    store_accessor :data, :categories

    fetcher :provider, [:provider]
  end
end
