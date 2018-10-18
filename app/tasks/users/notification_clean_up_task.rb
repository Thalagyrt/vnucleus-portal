module Users
  class NotificationCleanUpTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      Users::Notification.clean_up
    end
  end
end