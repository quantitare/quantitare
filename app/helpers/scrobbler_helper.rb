# frozen_string_literal: true

##
# Scrobbler-related view & controller helpers go here.
#
module ScrobblerHelper
  def scrobbler_type_select_options
    Rails.cache.fetch(__method__) do
      Scrobbler.types.map { |type| [humanize_type(type.name), type] }
    end
  end

  def scrobbler_provider_options(scrobbler)
    scrobbler.valid_services_for(current_user).map do |service|
      service = service.decorate
      [service.label_text, service.id]
    end
  end
end
