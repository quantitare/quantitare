# frozen_string_literal: true

##
# CRUD for external services.
#
class ServicesController < AuthenticatedController
  def index
    @services = current_user.services
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_path }
      format.json { head :no_content }
    end
  end
end
