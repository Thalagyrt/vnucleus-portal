module Solus
  class TriggerPatchIncidentJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(Rails.application.config.pagerduty[:low_api_key]) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}"}

      server.with_lock do
        return if server.patch_incident_key.present?

        Rails.logger.info { "Triggering PagerDuty incident for server #{server}"}

        incident = pagerduty.trigger("Server #{server.to_s} is due for patching")

        server.update_attributes patch_incident_key: incident.incident_key
      end
    end

    private
    attr_accessor :server, :pagerduty
  end
end