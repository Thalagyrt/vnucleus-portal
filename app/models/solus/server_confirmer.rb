module Solus
  class ServerConfirmer
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @user = opts[:user]
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
    end

    def confirm
      server.confirm!
      log_confirmation
      schedule_billing
      send_email
      send_notifications
      publish(:confirm_success)
    end

    private
    attr_reader :server, :user, :event_logger
    delegate :account, to: :server

    def log_confirmation
      event_logger.with_entity(@server).with_category(:event).log(:server_confirmed)
    end

    def schedule_billing
      Delayed::Job.enqueue ServerOrderBillingJob.new(server: server)
    end

    def send_email
      mailer_services.each do |mailer_service|
        mailer_service.server_confirmed(server: server)
      end
    end

    def mailer_services
      [::Accounts::MailerService.new(account: account), ::Admin::MailerService.new]
    end

    def send_notifications
      notification_services.each do |notification_service|
        notification_service.server_confirmed(target: server, actor: user)
      end
    end

    def notification_services
      [::Admin::NotificationService.new]
    end
  end
end