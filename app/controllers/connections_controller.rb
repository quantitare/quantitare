# frozen_string_literal: true

##
# Manages integrated "connection" flow for {Service} + {Scrobbler} creation
#
class ConnectionsController < ApplicationController
  respond_to :js, only: [:create, :update]

  before_action :authenticate_user!
  before_action :ensure_exclusive_params, only: [:new]

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  def index
    @scrobblers = current_user.scrobblers.all.order(created_at: :desc).includes(:service)
  end

  def show
    @scrobbler = current_user.scrobblers.find params[:id]
  end

  def new
    new_from_service if params[:service_id]
    new_from_provider if params[:provider]
  end

  def create
    @scrobbler = current_user.scrobblers.new scrobbler_params

    if @scrobbler.save
      redirect_to connections_path
    else
      respond_with @scrobbler
    end
  end

  def update
    @scrobbler = current_user.scrobblers.find params[:id]
    @scrobbler.update scrobbler_params

    respond_with @scrobbler, location: -> { connections_path }
  end

  def destroy
    @scrobbler = current_user.scrobblers.find params[:id]
    @scrobbler.destroy

    respond_with @scrobbler, location: -> { connections_path }
  end

  private

  def scrobbler_params
    params.require(:scrobbler).permit(
      :type, :name, :service_id, :earliest_data_at, :enabled,
      schedules: {}, options_attributes: {}
    )
  end

  def ensure_exclusive_params
    return unless params[:service_id] && params[:provider]

    flash[:danger] = 'Cannot initialize a connection with both a service_id and a provider!'
    redirect_to connections_path
  end

  def new_from_service
    @service = Service.find params[:service_id]

    if @service.scrobblers.exists?
      connection_exists
    else
      @scrobbler = current_user.scrobblers.new_from_service(@service, name: name_from_service)
    end
  end

  def name_from_service
    "#{omniauth_provider_name(@service.provider)} (#{@service.name})"
  end

  def new_from_provider
    @provider = Provider.find params[:provider]

    if @provider&.oauth?
      redirect_to user_omniauth_authorize_path(@provider.name)
    else
      @scrobbler = current_user.scrobblers.new_from_provider(params[:provider], name: name_from_provider)
    end
  end

  def name_from_provider
    params[:provider].titleize
  end

  def connection_exists
    flash[:primary] = <<~TEXT.squish
      Your connection to #{t("devise.omniauth_providers.#{@service.provider}")} (#{@service.name}) has been established.
    TEXT

    redirect_to connection_path(@service.scrobblers.last)
  end
end
