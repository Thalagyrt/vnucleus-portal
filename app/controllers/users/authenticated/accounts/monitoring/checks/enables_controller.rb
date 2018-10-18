module Users
  module Authenticated
    module Accounts
      module Monitoring
        module Checks
          class EnablesController < ::Users::Authenticated::Accounts::Monitoring::Checks::ApplicationController
            before_filter :ensure_can_enable

            def create
              @check.update_attributes enabled: true

              flash[:notice] = 'The check has been enabled.'
              redirect_to [:users, @account, :monitoring, @check]
            end

            private
            def ensure_can_enable
              return if @check.can_enable?

              flash[:alert] = 'The check cannot be enabled.'
              redirect_to [:users, @account, :monitoring, @check]
            end
          end
        end
      end
    end
  end
end