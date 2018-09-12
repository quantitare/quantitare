# frozen_string_literal: true

##
# CRUD for location categories
#
class LocationCategoriesController < AuthenticatedController
  def index
    render json: PlaceCategory.all.map(&:to_h)
  end
end
