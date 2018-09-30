# frozen_string_literal: true

##
# Adds presentation logic for a {PlaceMatch}
#
class PlaceMatchDecorator < Draper::Decorator
  delegate_all

  def enabled?
    persisted?
  end

  alias enabled enabled?

  def match_name
    new_record? || source_fields.key?(:name)
  end

  def match_coordinates
    new_record? || (source_fields.key?(:longitude) && source_fields.key?(:latitude))
  end
end
