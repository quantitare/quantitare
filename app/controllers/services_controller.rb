# frozen_string_literal: true

##
# CRUD for external services.
#
class ServicesController < AuthenticatedController
  def index
    @services = current_user.services
  end
end
