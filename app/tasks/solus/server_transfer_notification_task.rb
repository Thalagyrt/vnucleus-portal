module Solus
  class ServerTransferNotificationTask < DelayedSchedulerTask
    environments :all

    cron '0 0 * * *'

    def perform
      ::Solus::Server.find_active.each do |server|
        if server.used_transfer_percentage >= 75
          Delayed::Job.enqueue ::Solus::ServerTransferNotificationJob.new(server: server)
        end
      end
    end
  end
end