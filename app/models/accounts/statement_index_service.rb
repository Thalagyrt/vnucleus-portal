module Accounts
  class StatementIndexService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @transactions_scope = opts.fetch(:transactions_scope)
      @statement_class = opts.fetch(:statement_class) { Statement }
    end

    def statements
      dates.map { |d| statement_class.new(transactions_scope: transactions_scope, start_date: d) }
    end

    private
    attr_reader :account, :transactions_scope, :statement_class

    def dates
      (minimum_date..maximum_date).select { |d| d.day == 1 }
    end

    def minimum_date
      account.created_at.to_date.at_beginning_of_month
    end

    def maximum_date
      Time.zone.today.at_beginning_of_month
    end
  end
end