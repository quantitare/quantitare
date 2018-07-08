# frozen_string_literal: true

##
# Abstract application record
#
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
