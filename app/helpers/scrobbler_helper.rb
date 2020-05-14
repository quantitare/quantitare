# frozen_string_literal: true

##
# Scrobbler-related view & controller helpers go here.
#
module ScrobblerHelper
  def provider_select_options
    options_for_select(
      Provider.all.sort_by(&:name).map do |provider|
        [
          omniauth_provider_name(provider.name),
          provider.name,
          { data: { 'custom-properties': { icon: provider.icon.to_h } } }
        ]
      end
    )
  end

  def scrobbler_type_select_options
    Rails.cache.fetch(__method__) do
      Scrobbler.types.map { |type| [humanize_type(type.name), type.name] }.sort_by { |item| item[0] }
    end
  end

  def type_options_for_scrobbler(scrobbler)
    Scrobbler.types.map do |type|
      {
        label: humanize_type(type.name),
        value: type.name,
        selected: scrobbler.type.to_s == type.name
      }
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

  def scrobbler_schedule_options(_scrobbler)
    Scheduler.available_schedules.map { |schedule| [schedule, schedule] }
  end
end
