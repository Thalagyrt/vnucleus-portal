module Monitoring
  class AccountNotificationSender
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @email_notification_sender_klass = opts.fetch(:email_notification_sender_klass) { EmailNotificationSender }
    end

    def send_notification
      target_emails.each do |email|
        email_notification_sender_klass.new(check: check, target_value: email).send_notification
      end
    end

    private
    attr_reader :check, :email_notification_sender_klass
    delegate :server, to: :check
    delegate :account, to: :server

    def target_emails
      account.users.select { |u| Power.new(u).account_server_access? account }.map(&:email)
    end
  end
end