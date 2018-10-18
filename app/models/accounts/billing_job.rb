module Accounts
  class BillingJob
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @transactions = []
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { BatchTransactionService.new(account: account) }
      @automation_service = opts.fetch(:automation_service) { AutomationService.new(account: account) }
      @payment_service = opts.fetch(:payment_service) { PaymentService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account, category: :billing) }
    end

    def perform
      Rails.logger.info { "Fetched account #{account}" }

      account.with_lock do
        if account.close_on.present? && account.close_on <= Time.zone.now
          close_account
        else
          if bill_services?
            batch_transaction_service.batch do |batch|
              account.bill_services(batch, event_logger)
            end
          end

          check_favor
        end
      end
    end

    def max_attempts
      1
    end

    private
    attr_reader :account, :batch_transaction_service, :automation_service, :payment_service, :event_logger
    delegate :close_account, to: :automation_service

    def affiliate_recurring_factor
      Rails.application.config.affiliate_recurring_factor
    end

    def bill_services?
      Rails.application.config.billing_enabled
    end

    def check_favor
      if account.balance_favorable?
        automation_service.in_favor
      else
        automation_service.out_of_favor
        payment_service.charge_balance
      end
    end
  end
end