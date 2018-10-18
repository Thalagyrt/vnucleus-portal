module Solus
  class ServerPrunerTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      ::Solus::Server.find_stale_orders.each do |server|
        Rails.logger.info { "Cancelling order of server #{server}" }
        server.cancel_order
      end
    end
  end
end