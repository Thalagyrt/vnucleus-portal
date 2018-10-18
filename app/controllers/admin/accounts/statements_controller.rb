module Admin
  module Accounts
    class StatementsController < Admin::Accounts::ApplicationController
      decorates_assigned :statement, :statements

      power :admin_account_transactions, context: :load_account, as: :transactions_scope

      def index
        @statements = ::Accounts::StatementIndexService.new(account: @account, transactions_scope: transactions_scope).statements
      end

      def show
        @statement = ::Accounts::Statement.new(transactions_scope: transactions_scope, start_date: start_date)
      end

      private
      def start_date
        Date.parse("#{params[:id]}-01")
      end
    end
  end
end