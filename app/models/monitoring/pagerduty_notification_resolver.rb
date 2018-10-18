module Monitoring
  class PagerdutyNotificationResolver
    def initialize(opts = {})
      @notification = opts.fetch(:notification)
      @pagerduty = opts.fetch(:pagerduty) { Pagerduty.new(target_value) }
    end

    def resolve
      begin
        Rails.logger.info { "Resolving by PagerDuty to #{target_value}/#{target_key}" }

        incident = pagerduty.get_incident(target_key)
        incident.resolve(status_message)
      rescue => e
        Rails.logger.error { "Failed to resolve PagerDuty incident: #{e.message}" }
      end
    end

    private
    attr_reader :notification, :pagerduty
    delegate :target_value, :target_key, :check, to: :notification
    delegate :status_message, to: :check
  end
end