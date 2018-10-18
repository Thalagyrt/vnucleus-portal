module Monitoring
  class StaffNotificationSender
    PagerDutyApiKeys = {
        high: Rails.application.config.pagerduty[:high_api_key],
        low: Rails.application.config.pagerduty[:low_api_key],
    }

    def initialize(opts = {})
      @check = opts.fetch(:check)
      @pagerduty_notification_sender = opts.fetch(:pagerduty_notification_sender) { PagerdutyNotificationSender.new(check: check, target_value: api_key) }
      @email_notification_sender_klass = opts.fetch(:email_notification_sender_klass) { EmailNotificationSender }
    end

    def send_notification
      pagerduty_notification_sender.send_notification

      target_emails.each do |email|
        email_notification_sender_klass.new(check: check, target_value: email).send_notification
      end
    end

    private
    attr_reader :check, :pagerduty_notification_sender, :email_notification_sender_klass
    delegate :priority, to: :check

    def api_key
      PagerDutyApiKeys[priority.to_sym]
    end

    def target_emails
      Users::User.staff.pluck(:email)
    end
  end
end