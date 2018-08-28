# frozen_string_literal: true

json.key_format! camelize: :lower

json.ready @scrobbler.type.present? && @scrobbler.type != 'Scrobbler'
json.requires_provider @scrobbler.requires_provider?
json.provider_options options_for_select(scrobbler_provider_options(@scrobbler))
