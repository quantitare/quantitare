# frozen_string_literal: true

json.key_format! camelize: :lower

json.ready @scrobbler.type.present? && @scrobbler.type != 'Scrobbler'

json.requires_provider @scrobbler.requires_provider?
json.provider_options scrobbler_provider_options(@scrobbler)

json.options do
  json.array! @scrobbler.options_config_for(:options) do |config|
    json.name config[:name]
    json.type config[:type]
    json.default config[:default]
    json.display config[:display] || {}
    json.required config[:required]

    json.value @scrobbler.options.public_send(config[:name]) || config[:default]
  end
end
