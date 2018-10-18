module Monitoring
  class NotificationSenderClassFinder
    SenderClasses = {
        pagerduty: PagerdutyNotificationSender,
        email: EmailNotificationSender,
    }

    def for_target(target)
      SenderClasses[target.target_type.to_sym]
    end
  end
end