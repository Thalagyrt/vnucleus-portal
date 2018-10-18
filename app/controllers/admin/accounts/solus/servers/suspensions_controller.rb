module Admin
  module Accounts
    module Solus
      module Servers
        class SuspensionsController < Admin::Accounts::Solus::Servers::ApplicationController
          before_filter :ensure_active

          def create
            server_suspender.on(:suspend_success) do
              flash[:notice] = "The server has been suspended."
              redirect_to [:admin, @account, :solus, @server]
            end

            server_suspender.suspend(suspension_params)
          end

          private
          def server_suspender
            @server_suspender ||= ::Solus::ServerSuspender.new(server: @server, event_logger: account_event_logger)
          end

          def ensure_active
            unless @server.active?
              flash[:notice] = "This server is not in a state that allows suspension."
              redirect_to [:admin, @account, :solus, @server]
            end
          end

          def suspension_params
            params.require(:server).permit(:suspension_reason)
          end
        end
      end
    end
  end
end