module Monitoring
  class PagerdutyNotificationSender
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @api_key = opts.fetch(:target_value)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(api_key) }
    end

    def send_notification
      return if current_notification.present?

      begin
        Rails.logger.info { "Notifying by PagerDuty to #{api_key}" }

        incident = pagerduty.trigger(check.status_message)

        notifications.create(
            target_type: :pagerduty,
            target_value: api_key,
            target_key: incident.incident_key,
            current_priority: priority,
        )
      rescue => e
        Rails.logger.error { "Failed to open PagerDuty incident: #{e.message}" }
      end
    end

    private
    attr_reader :check, :api_key, :pagerduty
    delegate :notifications, :priority, to: :check

    def current_notification
      notifications.current_for_target(:pagerduty, api_key)
    end
  end
end