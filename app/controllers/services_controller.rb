# frozen_string_literal: true

##
# CRUD for external services.
#
class ServicesController < AuthenticatedController
  def index
    @services = current_user.services.order(provider: :asc)
  end

  def update
    @service = current_user.services.find(params[:id]).decorate

    if @service.update(service_params)
      flash.now[:success] = "#{@service.friendly_model_name} successfully saved!"
    else
      flash.now[:danger] = "There were some errors saving #{@service.friendly_model_name}"
    end
  end

  def destroy
    @service = current_user.services.find(params[:id])
    @service.destroy

    respond_to do |format|
      format.html { redirect_to services_path }
      format.json { head :no_content }
    end
  end

  private

  def service_params
    params.require(service_key).permit(*permitted_attributes)
  end

  def service_key
    params[:service].present? ? :service : "service_#{@service.try(:id)}"
  end

  def permitted_attributes
    current_user.admin? ? [:global] : []
  end
end
