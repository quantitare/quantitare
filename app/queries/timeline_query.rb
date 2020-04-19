# frozen_string_literal: true

##
# General superclass for querying {Periodable} records for a given set of timeline parameters
#
class TimelineQuery < ApplicationQuery
  InvalidScaleError = DateScale::InvalidScaleError

  SCALES = [
    SCALE_DAY = 'day',
    SCALE_WEEK = 'week',
    SCALE_MONTH = 'month',
    SCALE_YEAR = 'year'
  ].freeze

  delegate :from, :to, to: :date_scale

  def call
    @relation = relation.overlapping_range(from, to)

    relation
  end

  private

  def date_scale
    @date_scale ||= DateScale.new(date, scale)
  end
end
