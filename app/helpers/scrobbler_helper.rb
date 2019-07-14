# frozen_string_literal: true

##
# Scrobbler-related view & controller helpers go here.
#
module ScrobblerHelper
  def scrobbler_type_select_options
    Rails.cache.fetch(__method__) do
      Scrobbler.types.map { |type| [humanize_type(type.name), type.name] }.sort_by { |item| item[0] }
    end
  end

  def scrobbler_provider_options(scrobbler)
    scrobbler.valid_services_for(current_user).map do |service|
      service = service.decorate

      {
        label: service.label_text,
        value: service.id,
        selected: scrobbler.service == service
      }
    end
  end

  def scrobbler_status_badge(scrobbler)
    working = scrobbler.working?
    text = working ? 'OK' : 'Error'
    type = working ? 'success' : 'danger'

    badge_tag text, type: type
  end
end
