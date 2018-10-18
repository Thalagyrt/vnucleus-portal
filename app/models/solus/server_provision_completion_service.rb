module Solus
  class ServerProvisionCompletionService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @mailer_service = opts.fetch(:mailer_service) { ::Accounts::MailerService.new(account: account) }
      @event_logger = opts.fetch(:account_event_logger) { ::Accounts::EventLogger.new(account: account) }
      @notification_service = opts.fetch(:notification_service) { ::Accounts::NotificationService.new(account: account) }
    end

    def provision_complete
      if server.complete
        Rails.logger.info { "Provisioned server #{server}" }

        server.monitoring_reset
        mailer_service.server_provisioned(server: server)
        event_logger.with_category(:automation).with_entity(server).log(:server_installed)
        notification_service.server_provisioned(target: server)
        template.log_install_time(server.provision_duration)
      end
    end

    private
    attr_reader :server, :mailer_service, :event_logger, :notification_service
    delegate :account, to: :server
    delegate :template, to: :server
  end
end