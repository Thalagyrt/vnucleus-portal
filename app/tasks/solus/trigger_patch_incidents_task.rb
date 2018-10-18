module Solus
  class TriggerPatchIncidentsTask < DelayedSchedulerTask
    environments :all

    cron '0 12 * * *'

    def perform
      ::Solus::Server.find_pending_patch_incidents.each do |server|
        Delayed::Job.enqueue ::Solus::TriggerPatchIncidentJob.new(server: server)
      end
    end
  end
end