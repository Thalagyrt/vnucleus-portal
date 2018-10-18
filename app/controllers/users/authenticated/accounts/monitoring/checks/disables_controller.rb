module Users
  module Authenticated
    module Accounts
      module Monitoring
        module Checks
          class DisablesController < ::Users::Authenticated::Accounts::Monitoring::Checks::ApplicationController
            def create
              @check.update_attributes enabled: false

              flash[:notice] = 'The check has been disabled.'
              redirect_to [:users, @account, :monitoring, @check]
            end
          end
        end
      end
    end
  end
end