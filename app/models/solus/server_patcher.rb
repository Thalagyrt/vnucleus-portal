module Solus
  class ServerPatcher
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @mailer_service = opts.fetch(:mailer_service) { ::Accounts::MailerService.new(account: account) }
      @resolve_patch_incident_job_class = opts.fetch(:resolve_patch_incident_job_class) { ResolvePatchIncidentJob }
    end

    def patch
      if server.patched!
        event_logger.with_category(:event).with_entity(server).log(:server_patched)
        mailer_service.server_patched(server: server)
        resolve_pagerduty_incident
        publish :patch_success
      else
        publish :patch_failure
      end
    end

    private
    attr_reader :server, :event_logger, :mailer_service, :resolve_patch_incident_job_class
    delegate :account, to: :server

    def resolve_pagerduty_incident
      Delayed::Job.enqueue resolve_patch_incident_job_class.new(server: server)
    end
  end
end