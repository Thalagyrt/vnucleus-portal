module Accounts
  class BillingTask < DelayedSchedulerTask
    environments :all

    cron '0 0 * * *'

    def perform
      accounts_to_be_billed.find_each do |account|
        Delayed::Job.enqueue ::Accounts::BillingJob.new(account: account)
      end
    end

    private
    def accounts_to_be_billed
      ::Accounts::Account.find_active
    end
  end
end