# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! service,
  :id, :provider, :name, :options, :global, :provider_options, :display_name

json.partial! 'shared/model_props', model: service
