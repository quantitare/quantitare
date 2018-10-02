# frozen_string_literal: true

json.key_format! camelize: :lower

json.partial! 'service', collection: @services, as: :service
