# frozen_string_literal: true

##
# Date/Time helpers for a given date and scale
#
class DateScale
  class InvalidScaleError < StandardError; end

  attr_reader :date, :scale

  def initialize(date, scale)
    @date = date
    @scale = scale
  end

  def beginning_of_scale
    date.public_send("beginning_of_#{scale}")
  rescue NoMethodError
    raise InvalidScaleError, "Scale type :#{scale} is not valid."
  end

  alias from beginning_of_scale

  def end_of_scale
    date.public_send("end_of_#{scale}")
  rescue NoMethodError
    raise InvalidScaleError, "Scale type :#{scale} is not valid."
  end

  alias to end_of_scale

  def previous_date
    (beginning_of_scale - 1).to_date
  end

  def next_date
    (end_of_scale + 1).to_date
  end
end
