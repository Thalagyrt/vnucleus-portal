module Users
  module Authenticated
    module Accounts
      class PaymentsController < Accounts::ApplicationController
        before_filter :ensure_payment_access!

        def new
          @payment_form = ::Accounts::PaymentForm.new
        end

        def create
          payment_creator.on(:create_success) do
            flash[:notice] = 'Thank you for your payment!'
            redirect_to [:users, @account, :statements]
          end

          payment_creator.on(:create_failure) do |payment_form|
            @payment_form = payment_form
            render :new
          end

          payment_creator.create(payment_form_params)
        end

        private
        def ensure_payment_access!
          current_power.account_payments!(@account)
        end

        def payment_creator
          @payment_creator ||= ::Accounts::PaymentCreator.new(account: @account, event_logger: account_event_logger)
        end

        def payment_form_params
          params.require(:payment_form).permit(:amount_dollars)
        end
      end
    end
  end
end