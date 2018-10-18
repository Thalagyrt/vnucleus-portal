module Solus
  class ServerOrderBillingJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @batch_transaction_service = opts.fetch(:batch_transaction_service) { ::Accounts::BatchTransactionService.new(account: account) }
      @automation_service = opts.fetch(:automation_service) { ::Accounts::AutomationService.new(account: account) }
      @payment_service = opts.fetch(:payment_service) { ::Accounts::PaymentService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account, entity: server, category: :billing) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      server.with_lock do
        abort_job unless server.pending_billing?

        batch_transaction_service.batch do |batch|
          if server.amount > 0
            Rails.logger.info { "Charging #{MoneyFormatter.format_amount(server.prorated_amount)} to account #{account}" }

            batch.add_debit(server.prorated_amount, "Server #{server.to_s} prorated to #{server.next_due} (First Charge)")
            event_logger.log(:server_billed)
          end
          server.billed
        end

        if account.balance_favorable?
          automation_service.in_favor
        else
          payment_service.charge_balance
        end
      end
    end

    def max_attempts
      2
    end

    private
    attr_reader :server, :batch_transaction_service, :automation_service, :payment_service, :event_logger
    delegate :account, to: :server

    def abort_job
      raise AbortDelayedJob.new("Billing of server ##{server.id} failed")
    end
  end
end