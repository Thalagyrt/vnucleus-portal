module Admin
  module Accounts
    class ActivationsController < Admin::Accounts::ApplicationController
      before_filter :ensure_pending!

      def create
        activator.on(:activate_success) do
          flash[:notice] = 'The account has been activated.'
          redirect_to [:admin, @account]
        end

        activator.activate
      end
      
      def destroy
        rejector.on(:reject_success) do
          flash[:notice] = 'The account has been rejected.'
          redirect_to [:admin, @account]
        end
        rejector.on(:reject_failure) do
          flash[:alert] = 'The account was unable to be rejected. Check preconditions.'
          redirect_to [:admin, @account]
        end
        
        rejector.reject
      end

      private
      def ensure_pending!
        render_404 unless @account.pending_activation?
      end

      def activator
        @activator ||= ::Accounts::AccountActivator.new(account: @account, event_logger: account_event_logger)
      end

      def rejector
        @rejector ||= ::Accounts::AccountRejector.new(account: @account, event_logger: account_event_logger)
      end
    end
  end
end