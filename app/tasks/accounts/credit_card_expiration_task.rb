module Accounts
  class CreditCardExpirationTask < DelayedSchedulerTask
    environments :all

    cron '0 0 1 * *'

    def perform
      ::Accounts::Account.find_active.with_expiring_credit_card.find_each do |account|
        Delayed::Job.enqueue ::Accounts::CreditCardExpirationJob.new(account: account)
      end
    end
  end
end