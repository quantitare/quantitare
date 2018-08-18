# frozen_string_literal: true

##
#
#
module Typeable
  extend ActiveSupport::Concern

  included do
    validate :validate_type
  end


end
