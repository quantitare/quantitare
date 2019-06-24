Sidekiq.configure_server do |config|
  config.on(:startup) do
    Sidekiq.schedule ||= {}
    Sidekiq.schedule = Sidekiq.schedule.merge(Scheduler.sidekiq_scheduler_options)
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end
