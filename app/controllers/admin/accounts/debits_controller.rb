module Admin
  module Accounts
    class DebitsController < Admin::Accounts::ApplicationController
      def new
        current_power.creatable_admin_account_transactions!(@account)

        @transaction_form = ::Accounts::TransactionForm.new
      end

      def create
        current_power.creatable_admin_account_transactions!(@account)

        @transaction_form = ::Accounts::TransactionForm.new(transaction_form_params)

        if @transaction_form.valid?
          ::Accounts::BatchTransactionService.new(account: @account).batch do |batch|
            batch.add_debit(@transaction_form.amount, @transaction_form.description)
          end
          flash[:notice] = 'The debit has been added.'
          redirect_to [:admin, @account, :statements]
        else
          render :new
        end
      end

      private
      def transaction_form_params
        params.require(:transaction_form).permit(:amount_dollars, :description)
      end
    end
  end
end