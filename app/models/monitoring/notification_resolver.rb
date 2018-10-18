module Monitoring
  class NotificationResolver
    def initialize(opts = {})
      @check = opts.fetch(:check)
      @notification_resolver_class_finder = opts.fetch(:notification_resolver_class_finder) { NotificationResolverClassFinder.new }
    end

    def resolve(priority)
      notifications.with_current_priority(priority).find_each do |notification|
        notification.with_lock do
          next if notification.resolved?

          notification.resolve! if notification_resolver_class_finder.for_notification(notification).new(notification: notification).resolve
        end
      end
    end

    private
    attr_reader :check, :notification_resolver_class_finder
    delegate :notifications, to: :check
  end
end