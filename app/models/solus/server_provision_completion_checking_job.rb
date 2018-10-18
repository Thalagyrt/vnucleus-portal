module Solus
  class ServerProvisionCompletionCheckingJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @provision_id = opts.fetch(:provision_id)
      @admin_mailer_service = opts.fetch(:mailer_service) { ::Admin::MailerService.new }
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(Rails.application.config.pagerduty[:high_api_key]) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      return unless provision_id == server.provision_id
      return unless server.provisioning?

      Rails.logger.warn { "Provision stalled for server #{server}" }

      admin_mailer_service.provision_stalled(server: server)
      pagerduty.trigger("Server #{server.to_s} provisioning stalled!")
    end

    private
    attr_accessor :server, :pagerduty, :admin_mailer_service, :provision_id
  end
end