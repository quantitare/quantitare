# frozen_string_literal: true

##
# Macros enabling a class to describe how it understands a given time interval.
#
module Intervalable
  extend ActiveSupport::Concern

  included do
    class_attribute :interval_batch_scale, instance_writer: false, default: :time
    class_attribute :interval_start_inclusive, instance_writer: false, default: true
    class_attribute :interval_end_inclusive, instance_writer: false, default: true

    delegate :normalize_times, :normalize_time, :denormalize_times, :denormalize_time, to: :class
  end

  class_methods do
    def batch_intervals_by(scale, start_is: :inclusive, end_is: :inclusive)
      self.interval_batch_scale = scale

      self.interval_start_inclusive = start_is == :inclusive
      self.interval_end_inclusive = end_is == :inclusive
    end

    def normalize_times(*times)
      times.map { |time| interval_batch_scale == :date ? time.to_date : time }
    end

    def normalize_time(time)
      normalize_times(time).first
    end

    def denormalize_times(*times)
      return times if times.length.zero?
      return [denormalize_time(times.first, :middle_of_day)] if times.length == 1

      denormalized_times = []

      denormalized_times << denormalize_time(times.first, :beginning_of_day)
      denormalized_times += times[1...-1].map { |time| denormalize_time(time, :middle_of_day) }
      denormalized_times << denormalize_time(times.last, :end_of_day)

      denormalized_times
    end

    def denormalize_time(time, day_target = :beginning_of_day)
      interval_batch_scale == :date ? time.public_send(day_target) : time
    end
  end
end
