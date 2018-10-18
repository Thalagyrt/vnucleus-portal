module Monitoring
  class EmailNotificationResolver
    def initialize(opts = {})
      @notification = opts.fetch(:notification)
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    def resolve
      Rails.logger.info { "Notifying by email to #{email}" }

      mailer.delay.check_status(check: check, email: email)
    end

    private
    attr_reader :notification, :mailer
    delegate :check, to: :notification

    def email
      notification.target_value
    end
  end
end