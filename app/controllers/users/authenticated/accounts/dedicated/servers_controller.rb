module Users
  module Authenticated
    module Accounts
      module Dedicated
        class ServersController < ::Users::Authenticated::Accounts::ApplicationController
          power :account_dedicated_servers, context: :load_account, as: :servers_scope

          decorates_assigned :server, :servers, :plans, :templates, :clusters

          def index
            @servers = servers_scope
            @servers = @servers.find_current unless params[:show_all].present?
          end

          def show
            @server = servers_scope.includes(events: [:user]).find_by_param(params[:id])

            ::Users::Notification.where(user: current_user, target: @server).mark_all_read
          end
        end
      end
    end
  end
end