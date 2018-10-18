module Monitoring
  class CheckRunnerJob
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @notification_sender = opts.fetch(:notification_sender) { NotificationSender.new(check: check) }
      @notification_resolver = opts.fetch(:notification_resolver) { NotificationResolver.new(check: check) }
      @check_class_finder = opts.fetch(:check_class_finder) { CheckClassFinder.new(check: check) }
    end

    def perform
      check.with_lock do
        return unless next_run_at < Time.zone.now

        Rails.logger.info { "Running #{check.to_s}" }

        if check.active?
          check_class.new(check).perform

          Rails.logger.info { check.status_message }

          notification_sender.send_notification if should_notify?
          notification_resolver.resolve(:low) if should_resolve_low?
          notification_resolver.resolve(:high) if should_resolve_high?
        end
      end
    end

    def max_attempts
      1
    end

    private
    attr_reader :check, :notification_sender, :notification_resolver, :check_class_finder
    delegate :server, :next_run_at, :should_notify?, :should_resolve_low?, :should_resolve_high?, to: :check
    delegate :check_class, to: :check_class_finder
  end
end