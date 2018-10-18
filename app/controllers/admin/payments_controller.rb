module Admin
  class PaymentsController < Admin::ApplicationController
    decorates_assigned :transactions

    power :admin_transactions, as: :transactions_scope

    def index
      @transactions = transactions_scope.find_payments.includes(:account)

      @payments_by_month = transactions_scope.payments_by_month
      
      respond_to do |format|
        format.html
        format.json { render json: PaymentsDatatable.new(@transactions, view_context) }
      end
    end
  end
end