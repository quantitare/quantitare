# frozen_string_literal: true

##
# Handles omniauth callbacks.
#
class OmniauthCallbacksController < ApplicationController
  def action_missing(action_name)
    case action_name.to_sym
    when *Devise.omniauth_providers
      @service = handle_omniauth

      if @service
        flash[:success] = "Successfully added #{action_name.humanize}!"
      else
        flash[:danger] = "An error occurred while trying to add #{action_name.humanize}."
      end
    else
      flash[:danger] = "We couldn't find a provider for #{action_name.humanize}"
    end

    redirect_to services_path
  end

  private

  def handle_omniauth
    service = current_user.services.find_or_initialize_via_omniauth(request.env['omniauth.auth'])
    service&.save
  end
end
