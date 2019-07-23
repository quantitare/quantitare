# frozen_string_literal: true

module Aux
  module Todoist
    ##
    # A cached representation of a "label" object in Todoist.
    #
    class Label < ServiceCache
      store_accessor :data, :name

      json_schema :data,
        Rails.root.join('app', 'models', 'json_schemas', 'aux', 'todoist', 'label_data_schema.json')

      fetcher :id, [:id]
    end
  end
end
