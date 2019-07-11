# frozen_string_literal: true

##
# Shared logic for setting a period value on an +ActiveRecord+ model. Requres that the model have three attributes:
# +start_time+, +end_time+, and +period+, with datatypes +timestamp+, +timestamp+ and +tsrange+, respectively.
#
# Also adds a scope called +overlapping_range+ which allows you to find records that overlap the range you give it. For
# example, if I have a record of type +MyModel+ whose +start_time+ is today at 5:00PM and +end_time+ is today at
# 10:00PM, then +MyModel.overlapping_range(<Today at 4:00PM>, <Today at 6:00PM>)+ will include that record.
#
module Periodable
  extend ActiveSupport::Concern

  included do
    before_save :set_period

    scope :overlapping_range, ->(from, to) { where("#{table_name}.period && ?", "[#{from},#{to}]") }
  end

  def any_times_changed?
    start_time_changed? || end_time_changed?
  end

  private

  def set_period
    return unless any_times_changed?

    self.period = start_time..end_time
  end
end
