module Monitoring
  class EnqueueChecksTask < DelayedSchedulerTask
    environments :all

    every '15s'

    def perform
      checks_to_run.find_each do |check|
        Delayed::Job.enqueue Monitoring::CheckRunnerJob.new(check: check)

        Rails.logger.info { "Enqueued check for #{check}"}
      end
    end

    private
    def checks_to_run
      ::Monitoring::Check.find_runnable
    end
  end
end