module Admin
  module Accounts
    class ApplicationController < Admin::ApplicationController
      power :admin_accounts, as: :accounts_scope

      before_filter :load_account

      decorates_assigned :account

      private
      def load_account
        @account ||= accounts_scope.find_by_param(params[:account_id])
      end

      def account_event_logger
        @account_event_logger ||= ::Accounts::EventLogger.new(account: @account, user: current_user, ip_address: request.remote_ip)
      end
    end
  end
end