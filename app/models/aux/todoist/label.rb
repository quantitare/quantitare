# frozen_string_literal: true

module Aux
  module Todoist
    ##
    # A cached representation of a "label" object in Todoist.
    #
    class Label < ServiceCache
      jsonb_accessor :data,
        identifier: :integer,
        name: :string,
        color: :integer

      json_schema :data,
        Rails.root.join('app', 'models', 'json_schemas', 'aux', 'todoist', 'label_data_schema.json')

      fetcher :identifier, [:identifier]
    end
  end
end
