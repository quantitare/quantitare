# frozen_string_literal: true

##
# Controllers inheriting from this require a logged-in user.
#
class AuthenticatedController < ApplicationController
  before_action :authenticate_user!
end
