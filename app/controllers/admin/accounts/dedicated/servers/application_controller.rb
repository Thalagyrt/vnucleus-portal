module Admin
  module Accounts
    module Dedicated
      module Servers
        class ApplicationController < ::Admin::Accounts::ApplicationController
          power :admin_account_dedicated_servers, context: :load_account, as: :servers_scope

          decorates_assigned :server

          before_filter :load_server

          private
          def load_server
            @server = servers_scope.find_by_param(params[:server_id])
          end
        end
      end
    end
  end
end