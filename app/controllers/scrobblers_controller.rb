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

    redirect_to scrobblers_path if @scrobbler.save
  end

  private

  def scrobbler_params
    params.require(:scrobbler).permit(:type, :name, :service_id, options: {})
  end
end
