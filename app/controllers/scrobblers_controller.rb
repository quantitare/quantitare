# frozen_string_literal: true

##
# Basic CRUD for {Scrobbler}s
#
class ScrobblersController < AuthenticatedController
  def index
    @scrobblers = current_user.scrobblers.all
  end

  def new
    @scrobbler = current_user.scrobblers.new
  end

  def create
    @scrobbler = current_user.scrobblers.new(scrobbler_params)
  end
end
