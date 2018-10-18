module Accounts
  class ReferrerPayoutJob
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { BatchTransactionService.new(account: referrer) }
    end

    def perform
      Rails.logger.info { "Fetched account #{account}" }

      account.with_lock do
        if referrer.affiliate_enabled?
          if monthly_rate > 0
            add_credit
          end
        end

        mark_paid
      end
    end

    private
    attr_reader :account, :transaction, :batch_transaction_service
    delegate :referrer, :monthly_rate, to: :account

    def add_credit
      Rails.logger.info { "Adding #{MoneyFormatter.format_amount(monthly_rate)} referral credit to account #{referrer}" }

      batch_transaction_service.batch do |batch|
        batch.add_referral(monthly_rate, "Three Month Commission (#{account.long_id})")
      end
    end

    def mark_paid
      account.update_attributes pay_referrer_at: nil
    end
  end
end