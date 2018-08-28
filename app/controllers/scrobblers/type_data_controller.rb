# frozen_string_literal: true

##
# Retrieves type data for a scrobbler of a given type.
#
class Scrobblers::TypeDataController < AuthenticatedController
  def show
    @scrobbler = current_user.scrobblers.new(type: params[:type])

    respond_to do |format|
      format.json
    end
  end
end
