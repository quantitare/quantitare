# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! service,
  :id, :provider, :name, :options, :global
