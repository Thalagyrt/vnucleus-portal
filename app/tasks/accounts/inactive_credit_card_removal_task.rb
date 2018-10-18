module Accounts
  class InactiveCreditCardRemovalTask < DelayedSchedulerTask
    environments :all

    cron '0 5 * * *'

    def perform
      accounts_eligible_for_card_removal.each do |account|
        next if account.solus_servers.find_current.present?
        next if account.licenses.find_current.present?

        Delayed::Job.enqueue ::Accounts::CreditCardRemovalJob.new(account: account)
      end
    end

    private
    def accounts_eligible_for_card_removal
      ::Accounts::Account.with_valid_credit_card.where('credit_card_updated_at < ?', Rails.application.config.credit_card_removal_period.ago)
    end
  end
end