module Accounts
  class ReferrerPayoutTask < DelayedSchedulerTask
    environments :all

    cron '0 12 * * *'

    def perform
      accounts_pending_payout.each do |account|
        Delayed::Job.enqueue ::Accounts::ReferrerPayoutJob.new(account: account)
      end
    end

    private
    def accounts_pending_payout
      ::Accounts::Account.where('pay_referrer_at <= ?', Time.zone.today)
    end
  end
end