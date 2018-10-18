module Accounts
  class BatchTransactionService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
    end

    def batch(&block)
      transactions = capture_batch(&block)

      unless transactions.empty?
        mailer_service.transactions_posted(transactions: transactions)
      end
    end

    private
    attr_reader :account, :mailer_service

    def capture_batch(&block)
      account.with_lock do
        batch = Batch.new

        block.call(batch)

        transactions = []

        batch.credits.each do |credit|
          transactions << account.add_credit(credit.amount, credit.description)
        end

        batch.referrals.each do |referral|
          transactions << account.add_referral(referral.amount, referral.description)
        end

        batch.debits.each do |debit|
          transactions << account.add_debit(debit.amount, debit.description)
        end

        transactions
      end
    end

    class Batch
      attr_reader :debits, :credits, :referrals

      def initialize
        @debits = []
        @credits = []
        @referrals = []
      end

      def add_debit(amount, description)
        debits << Transaction.new(amount, description)
      end

      def add_credit(amount, description)
        credits << Transaction.new(amount, description)
      end

      def add_referral(amount, description)
        referrals << Transaction.new(amount, description)
      end
    end

    class Transaction < Struct.new(:amount, :description); end
  end
end