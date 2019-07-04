# frozen_string_literal: true

##
# Provides scheduling and check logic to a model.
#
module Schedulable
  extend ActiveSupport::Concern

  class CheckNotFound < StandardError; end

  included do
    validates :earliest_data_at, presence: true

    scope :scheduled_for, ->(schedule) { Scrobblers::ScheduledForQuery.(all, schedule: schedule) }

    attribute :schedules, :json, default: DEFAULT_SCHEDULES
    attribute :earliest_data_at, :datetime, default: -> { 15.years.ago }
  end

  # A list of checks, ordered by depth
  CHECKS = [
    CHECK_FULL = 'full',
    CHECK_DEEP = 'deep',
    CHECK_MEDIUM = 'medium',
    CHECK_SHALLOW = 'shallow'
  ].freeze

  # A mapping of check names to the frequency at which the check should be executed. Override this in your subclass if
  # necessary. Users can override this as desired.
  DEFAULT_SCHEDULES = {
    CHECK_FULL => '7d',
    CHECK_DEEP => '1d',
    CHECK_MEDIUM => '6h',
    CHECK_SHALLOW => '5m'
  }.freeze

  # A mapping of check names to the distance back in time to which the check should look for data. Override this in your
  # subclass if necessary.
  CHECK_DEPTHS = {
    CHECK_DEEP => 1.month,
    CHECK_MEDIUM => 1.week,
    CHECK_SHALLOW => 1.day
  }.freeze

  # Looks up a registered check for a given schedule. If multiple checks are associated with the given schedule, returns
  # the "deepest" such check.
  #
  # @param schedule [String] the schedule whose check you wish to retrieve
  # @return [String, nil] the relevant check for the passed-in schedule, or nil if no such check exists
  def relevant_check_for_schedule(schedule)
    schedules
      .select { |_, value| value == schedule.to_s }
      .map(&:first)
      .min_by { |check| CHECKS.index(check) }
  end

  def valid_check?(check)
    CHECKS.include?(check)
  end

  private

  def range_for_check(check)
    raise CheckNotFound unless valid_check?(check)

    end_time = Time.current
    start_time = check == CHECK_FULL ? earliest_data_at : CHECK_DEPTHS[check].before(end_time)

    [start_time, end_time]
  end
end
