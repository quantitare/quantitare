# frozen_string_literal: true

##
# Shared logic for a entities that run a standard OAuth2 fresh token refresh. Includer must implement the methods
# +#fetch_refresh_data+ and +#process_refresh!+
#
module ServiceRefreshable
  extend ActiveSupport::Concern

  def process!
    response, refresh_params = fetch_refresh_data

    if response.success?
      process_refresh!(refresh_params)
    else
      raise Errors::ServiceConfigError.new(<<~TEXT.squish, nature: Service::IN_REFRESH_TOKEN)
        We couldn't refresh the access token for the service #{service.name}. You may need to re-authenticate with
        the service.
      TEXT
    end
  end
end
