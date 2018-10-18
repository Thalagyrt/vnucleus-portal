module Users
  module Authenticated
    module Accounts
      module Monitoring
        module Checks
          class ApplicationController < ::Users::Authenticated::Accounts::ApplicationController
            power :account_monitoring_checks, context: :load_account, as: :checks_scope

            decorates_assigned :check

            before_filter :load_check

            private
            def load_check
              @check = checks_scope.find_by_param(params[:check_id])
            end
          end
        end
      end
    end
  end
end