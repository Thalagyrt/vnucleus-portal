module Solus
  class ServerSynchronizationTask < DelayedSchedulerTask
    environments :all

    cron '*/15 * * * *'

    def perform
      ::Solus::Server.find_pending_synchronization.each do |server|
        Delayed::Job.enqueue ::Solus::ServerSynchronizationJob.new(server: server)
      end
    end
  end
end