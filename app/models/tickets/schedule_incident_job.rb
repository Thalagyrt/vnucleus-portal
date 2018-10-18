module Tickets
  class ScheduleIncidentJob
    def initialize(opts = {})
      @ticket = opts.fetch(:ticket)
    end

    def perform
      Rails.logger.info { "Fetched ticket #{ticket}"}

      ticket.with_lock do
        return if ticket.incident_key.present?

        if ticket.trigger_incident_at.nil? || new_incident_time < ticket.trigger_incident_at
          ticket.update_attributes trigger_incident_at: new_incident_time
        end
      end
    end

    private
    attr_accessor :ticket

    def new_incident_time
      Time.zone.now + incident_delay
    end

    def incident_delay
      Rails.application.config.tickets[:trigger_incident_after][ticket.priority.to_sym]
    end
  end
end