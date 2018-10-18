module Users
  class TokenCleanUpTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      Users::Token.clean_up
    end
  end
end