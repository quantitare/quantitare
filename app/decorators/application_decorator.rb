# frozen_string_literal: true

##
# Define methods for all decorated objects.
# Helpers are accessed through `helpers` (aka `h`).
#
class ApplicationDecorator < Draper::Decorator
  def model_name
    model.class.name.split('::').last.underscore.humanize.downcase
  end
end
