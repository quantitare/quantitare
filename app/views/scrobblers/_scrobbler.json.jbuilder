# frozen_string_literal: true

json.key_format! camelize: :lower

json.extract! scrobbler,
  :id, :type, :name, :service_id, :earliest_data_at, :schedules

json.options { json.merge! scrobbler.options.to_h }

json.partial! 'shared/model_props', model: scrobbler
