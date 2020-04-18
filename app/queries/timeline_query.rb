# frozen_string_literal: true

##
# General superclass for querying {Periodable} records for a given set of timeline parameters
#
class TimelineQuery < ApplicationQuery
  class InvalidScaleError < StandardError; end

  SCALES = [
    SCALE_DAY = 'day',
    SCALE_WEEK = 'week',
    SCALE_MONTH = 'month',
    SCALE_YEAR = 'year'
  ].freeze

  def call
    @relation = relation.overlapping_range(from, to)

    relation
  end

  private

  def from
    beginning_date_of_range.beginning_of_day
  end

  def beginning_date_of_range
    case scale.to_s.downcase
    when SCALE_DAY then date
    when SCALE_WEEK then date.beginning_of_week
    when SCALE_MONTH then date.beginning_of_month
    when SCALE_YEAR then date.beginning_of_year
    else
      raise InvalidScaleError
    end
  end

  def to
    end_date_of_range.end_of_day
  end

  def end_date_of_range
    case scale.to_s.downcase
    when SCALE_DAY then date
    when SCALE_WEEK then date.end_of_week
    when SCALE_MONTH then date.end_of_month
    when SCALE_YEAR then date.end_of_year
    else
      raise InvalidScaleError
    end
  end
end
