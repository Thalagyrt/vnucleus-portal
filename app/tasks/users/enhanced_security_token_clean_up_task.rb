module Users
  class EnhancedSecurityTokenCleanUpTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      Users::EnhancedSecurityToken.clean_up
    end
  end
end