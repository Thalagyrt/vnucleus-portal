module Solus
  class UsageUpdaterTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      Delayed::Job.enqueue ::Solus::UsageUpdaterJob.new
    end
  end
end