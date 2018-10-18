module Solus
  class BandwidthResetTask < DelayedSchedulerTask
    environments :all

    cron '0 12 1 * *'

    def perform
      ::Solus::Server.find_active.update_all used_transfer: 0
    end
  end
end