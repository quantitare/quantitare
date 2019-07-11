# frozen_string_literal: true

module Scheduler
  SCHEDULES_TO_CRON = {
    '1m' => '*/1 * * * *',
    '2m' => '*/2 * * * *',
    '5m' => '*/5 * * * *',
    '10m' => '*/10 * * * *',
    '30m' => '*/30 * * * *',
    '1h' => '0 * * * *',
    '2h' => '0 */2 * * *',
    '5h' => '0 */5 * * *',
    '12h' => '0 */12 * * *',
    '1d' => '0 0 * * *',
    '2d' => '0 0 */2 * *',
    '7d' => '0 0 * * 1'
  }.freeze

  class << self
    def sidekiq_scheduler_options
      SCHEDULES_TO_CRON.map do |schedule, cron|
        [
          "schedule_every_#{schedule}".to_sym,
          {
            cron: cron,
            class: RunSchedulesJob,
            args: [schedule]
          }
        ]
      end.to_h
    end
  end
end
