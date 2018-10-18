module Accounts
  class CreditCardExpirationSynchronizationTask < DelayedSchedulerTask
    environments :all

    cron '0 0 15 * *'

    def perform
      ::Accounts::Account.find_active.with_expired_credit_card.find_each do |account|
        Delayed::Job.enqueue ::Accounts::CreditCardExpirationSynchronizationJob.new(account: account)
      end
    end
  end
end