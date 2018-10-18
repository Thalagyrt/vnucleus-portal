module Accounts
  class Statement
    include ActiveModel::Model
    include Draper::Decoratable

    attr_reader :transactions_scope, :start_date, :end_date

    def initialize(opts = {})
      @transactions_scope = opts.fetch(:transactions_scope)
      @start_date = opts.fetch(:start_date)
      @end_date = start_date + opts.fetch(:period, 1.month)
    end

    def persisted?
      true
    end

    def id
      start_date.strftime("%Y-%m")
    end

    def to_s
      start_date.strftime("%B %Y")
    end

    def starting_balance
      transactions_scope.where('created_at < ?', start_date).total
    end

    def ending_balance
      starting_balance + transactions.total
    end

    def total_payments
      -total(:payment)
    end

    def total_refunds
      total(:refund)
    end

    def total_credits
      -total(:credit)
    end

    def total_referrals
      -total(:referral)
    end

    def total_debits
      total(:debit)
    end

    def total_category_credits
      -total([:payment, :credit, :referral])
    end

    def total_category_debits
      total([:debit, :refund])
    end

    def net_change
      transactions.total
    end

    def transactions
      transactions_scope.where('created_at >= ?', start_date).where('created_at < ?', end_date)
    end

    private
    def total(type)
      transactions.where(category: type).total
    end
  end
end