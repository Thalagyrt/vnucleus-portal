module Tickets
  class ResolveIncidentJob
    def initialize(opts = {})
      @ticket = opts.fetch(:ticket)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(pagerduty_api_key) }
    end

    def perform
      Rails.logger.info { "Fetched ticket #{ticket}"}

      ticket.with_lock do
        if ticket.incident_key.present? && ticket.pagerduty_api_key.present?
          Rails.logger.info { "Resolving PagerDuty incident for ticket #{ticket}"}

          incident = pagerduty.get_incident(ticket.incident_key)
          incident.resolve("Ticket updated by staff.")
        end

        ticket.update_attributes trigger_incident_at: nil, incident_key: nil, pagerduty_api_key: nil
      end
    end

    private
    attr_accessor :ticket, :pagerduty
    delegate :pagerduty_api_key, to: :ticket
  end
end