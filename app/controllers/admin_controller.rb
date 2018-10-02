# frozen_string_literal: true

##
# Parent controller for all controllers requiring admin access.
#
class AdminController < AuthenticatedController
  before_action :require_admin

  private

  def require_admin
    return if current_user.admin?

    flash[:danger] = 'You are not permitted to do that!'
    redirect_to root_path
  end
end
