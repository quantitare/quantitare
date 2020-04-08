# frozen_string_literal: true

##
# Handles omniauth callbacks.
#
class OauthCallbacksController < Devise::OmniauthCallbacksController
  def action_missing(action_name)
    case action_name.to_sym
    when *Devise.omniauth_providers
      omniauth_action
    else
      not_found_action
    end
  end

  private

  def omniauth_action
    @service = handle_omniauth

    if @service
      flash[:success] = "Successfully added #{action_name.humanize}!"

      redirect_to new_connection_path(service_id: @service.id)
    else
      flash[:danger] = "An error occurred while trying to add #{action_name.humanize}."

      redirect_to connections_path
    end
  end

  def handle_omniauth
    service = current_user.services.find_or_initialize_via_omniauth(request.env['omniauth.auth'])
    service&.clear_issues

    service&.save && service
  end

  def not_found_action
    flash[:danger] = "We couldn't find a provider for #{action_name.humanize}"

    redirect_to connections_path
  end
end
