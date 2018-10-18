module Monitoring
  class EmailNotificationSender
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @email = opts.fetch(:target_value)
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    def send_notification
      return if current_notification.present? && current_priority.to_sym == priority.to_sym

      Rails.logger.info { "Notifying by email to #{email}" }
      mailer.delay.check_status(check: check, email: email)

      if current_notification.present?
        current_notification.update_attributes current_priority: priority
      else
        notifications.create(
            target_type: :email,
            target_value: email,
            current_priority: priority,
        )
      end
    end

    private
    attr_reader :check, :email, :mailer
    delegate :notifications, :priority, to: :check
    delegate :current_priority, to: :current_notification

    def current_notification
      notifications.current_for_target(:email, email)
    end
  end
end