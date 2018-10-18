module Users
  module Authenticated
    module Accounts
      class ApplicationController < Users::Authenticated::ApplicationController
        before_filter :load_account
        decorates_assigned :account

        power :user_accounts, as: :account_scope

        private
        def load_account
          @account ||= account_scope.find_by_param(current_account_id)
        end

        def current_account_id
          params[:account_id]
        end

        def account_event_logger
          ::Accounts::EventLogger.new(account: @account, user: current_user, ip_address: request.remote_ip)
        end
      end
    end
  end
end