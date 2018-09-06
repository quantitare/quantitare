# frozen_string_literal: true

##
# Handles requests related to {Place}s
#
class PlacesController < AuthenticatedController
  def search
    @places = Place.available_to_user(current_user)
  end

  def new
  end
end
