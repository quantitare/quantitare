# frozen_string_literal: true

##
# A Scrobbler is an object that creates scrobbles. It checks a service or receives webhooks, logging data based on what
# it receives.
#
class Scrobbler < ApplicationRecord
  include HasGuid
  include Typeable
  include Oauthable
  include Optionable

  # A list of checks, ordered by depth
  CHECKS = [
    CHECK_FULL = 'full',
    CHECK_DEEP = 'deep',
    CHECK_MEDIUM = 'medium',
    CHECK_SHALLOW = 'shallow'
  ].freeze

  DEFAULT_SCHEDULES = {
    CHECK_FULL => '7d',
    CHECK_DEEP => '1d',
    CHECK_MEDIUM => '6h',
    CHECK_SHALLOW => '5m'
  }.freeze

  CHECK_DEPTHS = {
    CHECK_DEEP => 1.month,
    CHECK_MEDIUM => 1.week,
    CHECK_SHALLOW => 1.day
  }.freeze

  has_many :scrobbles, as: :source, dependent: :destroy
  belongs_to :user
  belongs_to :service, optional: true

  validates :name, presence: true
  validates :earliest_data_at, presence: true

  scope :scheduled_for, ->(schedule) { Scrobblers::ScheduledForQuery.(all, schedule: schedule) }

  attribute :schedules, :json, default: DEFAULT_SCHEDULES
  attribute :earliest_data_at, :datetime, default: -> { 15.years.ago }

  load_types_in 'Scrobblers'
  options_attribute :options

  def source_identifier
    "#{type}_#{id}"
  end

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

  def run_check(check)
    fetch_scrobbles(*range_for_check(check))
  end

  def range_for_check(check)
    start_time = Time.current
    end_time = check == CHECK_FULL ? earliest_data_at : CHECK_DEPTHS[check].before(start_time)

    [start_time, end_time]
  end

  def fetch_scrobbles(_start_time, _end_time)
    raise NotImplementedError
  end

  def create_scrobble(scrobble)
    scrobble = build_scrobble(scrobble)
    scrobble.save!

    scrobble
  end

  def build_scrobble(scrobble)
    scrobble =
      if scrobble.is_a?(Hash)
        scrobbles.build(scrobble)
      else
        scrobble.source = self
        scrobble
      end

    scrobble.user = user

    scrobble
  end

  def handle_webhook(_request)
    WebResponse.new(content: 'not implemented', status: 404)
  end
end
