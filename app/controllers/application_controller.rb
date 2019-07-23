# frozen_string_literal: true

##
# Application Controller
#
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  # before_action :configure_permitted_parameters, if: :devise_controller?

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

  private

  def not_found!
    render file: 'public/404.html', layout: false, status: :not_found
  end
end
