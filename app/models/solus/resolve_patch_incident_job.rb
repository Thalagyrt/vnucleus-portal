module Solus
  class ResolvePatchIncidentJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(Rails.application.config.pagerduty[:low_api_key]) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}"}

      server.with_lock do
        return unless server.patch_incident_key.present?

        Rails.logger.info { "Resolving PagerDuty incident for server #{server}"}

        incident = pagerduty.get_incident(server.patch_incident_key)
        incident.resolve("Server has been patched.")

        server.update_attributes patch_incident_key: nil
      end
    end

    private
    attr_accessor :server, :pagerduty
  end
end