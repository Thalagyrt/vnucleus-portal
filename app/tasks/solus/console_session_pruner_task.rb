module Solus
  class ConsoleSessionPrunerTask < DelayedSchedulerTask
    environments :all

    cron '*/15 * * * *'

    def perform
      ::Solus::ConsoleSession.find_stale.delete_all
    end
  end
end