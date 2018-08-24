# frozen_string_literal: true

##
# Scrobbler-related view & controller helpers go here.
#
module ScrobblerHelper
  def scrobbler_type_select_options
    Rails.cache.fetch(__method__) do
      [['Select a scrobbler type', 'Scrobbler', { title: '' }]] +
        Scrobbler.types.map { |type| [humanize_type(type.name), type] }
    end
  end
end
