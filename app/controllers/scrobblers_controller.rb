# frozen_string_literal: true

##
# Basic CRUD for {Scrobbler}s
#
class ScrobblersController < AuthenticatedController
  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  def index
    @scrobblers = current_user.scrobblers.all.order(created_at: :desc).includes(:service)
  end

  def new
    @scrobbler = current_user.scrobblers.new
  end

  def create
    @scrobbler = current_user.scrobblers.new(scrobbler_params)

    redirect_to scrobblers_path if @scrobbler.save
  end

  def edit
    @scrobbler = current_user.scrobblers.find(params[:id])
  end

  def update
    @scrobbler = current_user.scrobblers.find(params[:id])

    redirect_to scrobblers_path if @scrobbler.update(scrobbler_params)
  end

  def destroy
    @scrobbler = current_user.scrobblers.find(params[:id])

    @scrobbler.destroy

    redirect_to scrobblers_path
  end

  private

  def scrobbler_params
    params.require(scrobbler_key).permit(:type, :name, :service_id, :earliest_data_at, :enabled, options: {})
  end

  def scrobbler_key
    params[:scrobbler].present? ? :scrobbler : "scrobbler_#{@scrobbler.try(:id)}"
  end
end
