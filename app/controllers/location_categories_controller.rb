# frozen_string_literal: true

##
# CRUD for location categories
#
class LocationCategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: PlaceCategory.all.map(&:to_h)
  end
end
