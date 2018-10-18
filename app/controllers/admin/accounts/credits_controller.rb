module Admin
  module Accounts
    class CreditsController < Admin::Accounts::ApplicationController
      def new
        current_power.creatable_admin_account_transactions!(@account)

        @transaction_form = ::Accounts::TransactionForm.new
      end

      def create
        current_power.creatable_admin_account_transactions!(@account)

        @transaction_form = ::Accounts::TransactionForm.new(transaction_form_params)

        if @transaction_form.valid?
          ::Accounts::CreditService.new(account: @account).add_credit(@transaction_form.amount, @transaction_form.description)
          flash[:notice] = 'The credit has been added.'
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