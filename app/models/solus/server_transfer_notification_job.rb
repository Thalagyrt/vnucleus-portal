module Solus
  class ServerTransferNotificationJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account, entity: server, category: :event) }
      @mailer_service = opts.fetch(:mailer_service) { ::Accounts::MailerService.new(account: account) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      mailer_service.transfer_notification(server: server)
      event_logger.log(:transfer_notification_sent)
    end

    private
    attr_reader :server, :event_logger, :mailer_service
    delegate :account, to: :server
  end
end