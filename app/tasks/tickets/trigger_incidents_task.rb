module Tickets
  class TriggerIncidentsTask < DelayedSchedulerTask
    environments :all

    cron '* * * * *'

    def perform
      tickets_pending_incidents.each do |ticket|
        Delayed::Job.enqueue ::Tickets::TriggerIncidentJob.new(ticket: ticket)
      end
    end

    private
    def tickets_pending_incidents
      ::Tickets::Ticket.where('trigger_incident_at < ?', Time.zone.now)
    end
  end
end