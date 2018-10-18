module Tickets
  class TriggerIncidentJob
    def initialize(opts = {})
      @ticket = opts.fetch(:ticket)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(pagerduty_api_key) }
    end

    def perform
      Rails.logger.info { "Fetched ticket #{ticket}"}

      ticket.with_lock do
        return if ticket.incident_key.present?
        return unless ticket.trigger_incident_at.present?

        Rails.logger.info { "Triggering PagerDuty incident for ticket #{ticket}"}

        incident = pagerduty.trigger("Ticket #{ticket.to_s} requires attention!")

        ticket.update_attributes incident_key: incident.incident_key, pagerduty_api_key: pagerduty_api_key
      end
    end

    private
    attr_accessor :ticket, :pagerduty

    def pagerduty_api_key
      Rails.application.config.pagerduty[
          Rails.application.config.tickets[:pagerduty_api_key][ticket.priority.to_sym]
      ]
    end
  end
end