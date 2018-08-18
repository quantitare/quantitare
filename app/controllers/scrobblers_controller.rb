# frozen_string_literal: true

##
# Basic CRUD for {Scrobbler}s
#
class ScrobblersController < AuthenticatedController
  def index
    @scrobblers = current_user.scrobblers.all
  end
end
