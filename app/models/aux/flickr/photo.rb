# frozen_string_literal: true

module Aux
  module Flickr
    ##
    # A cached representation of a Photo entity on Flickr
    #
    class Photo < ServiceCache
      store_accessor :data, :title

      json_schema :data,
        Rails.root.join('app', 'models', 'json_schemas', 'aux', 'flickr', 'photo_data_schema.json')

      fetcher :id, [:id]
    end
  end
end
