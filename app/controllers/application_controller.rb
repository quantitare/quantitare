# frozen_string_literal: true

require 'application_responder'

##
# Application Controller
#
class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :omniauth_provider_name, :user_omniauth_authorize_path

  def authenticate_admin!
    authenticate_user!

    return if current_user.admin?

    flash[:danger] = 'You are not permitted to do that!'
    redirect_to root_path
  end

  def redirect_to(location, *args)
    if request.format.js?
      render js: "window.location='#{location}'"
    else
      super
    end
  end

  def user_omniauth_authorize_path(provider)
    send "user_#{provider}_omniauth_authorize_path"
  end

  def omniauth_provider_name(provider)
    t("devise.omniauth_providers.#{provider}")
  end

  private

  def not_found!
    render file: 'public/404.html', layout: false, status: :not_found
  end
end
