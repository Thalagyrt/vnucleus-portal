module Accounts
  class CreditService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @automation_service = opts.fetch(:automation_service) { AutomationService.new(account: account) }
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { BatchTransactionService.new(account: account) }
    end

    def add_credit(amount, description)
      Rails.logger.info { "Adding #{MoneyFormatter.format_amount(amount)} credit to account #{account}" }

      batch_transaction_service.batch do |batch|
        batch.add_credit(amount, description)
      end

      if account.balance_favorable?
        automation_service.in_favor
      end
    end

    private
    attr_reader :account, :automation_service, :batch_transaction_service
  end
end