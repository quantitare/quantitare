# frozen_string_literal: true

##
# Handles omniauth callbacks.
#
class OmniauthCallbacksController < AuthenticatedController
  def action_missing(action_name)
    case action_name.to_sym
    when *Devise.omniauth_providers
      if handle_omniauth
        redirect_to services_path, success: "Successfully added #{action_name}!"
      else
        redirect_to services_path, danger: "An error occurred while trying to add #{action_name}."
      end
    else
      redirect_to services_path, danger: "We couldn't find a provider for #{action_name}"
    end
  end

  private

  def handle_omniauth
    service = current_user.services.find_or_initialize_via_omniauth(request.env['omniauth.auth'])
    service&.save
  end
end
