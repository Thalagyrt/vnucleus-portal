module Monitoring
  class NotificationResolverClassFinder
    ResolverClasses = {
        pagerduty: PagerdutyNotificationResolver,
        email: EmailNotificationResolver,
    }

    def for_notification(notification)
      ResolverClasses[notification.target_type.to_sym]
    end
  end
end