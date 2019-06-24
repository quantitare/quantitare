# frozen_string_literal: true

##
# Runs all {Scrobbler}s matching a given schedule.
#
class RunSchedulesJob < ApplicationJob
  queue_as :schedule

  def perform(schedule)
    Scrobbler.scheduled_for(schedule).each { |scrobbler| process_scrobbler(scrobbler, schedule) }
  end

  def process_scrobbler(scrobbler, schedule)
    check = scrobbler.relevant_check_for_schedule(schedule)
    ScrobblerCheckJob.perform_later(scrobbler, check) if check.present?
  end
end
