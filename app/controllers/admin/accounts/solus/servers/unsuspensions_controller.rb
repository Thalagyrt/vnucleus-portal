module Admin
  module Accounts
    module Solus
      module Servers
        class UnsuspensionsController < Admin::Accounts::Solus::Servers::ApplicationController
          before_filter :ensure_suspended

          def create
            server_unsuspender.on(:unsuspend_success) do
              flash[:notice] = "The server has been unsuspended."
              redirect_to [:admin, @account, :solus, @server]
            end

            server_unsuspender.unsuspend
          end

          private
          def server_unsuspender
            @server_unsuspender ||= ::Solus::ServerUnsuspender.new(server: @server, event_logger: account_event_logger)
          end

          def ensure_suspended
            unless @server.suspended?
              flash[:notice] = "This server is not in a state that allows unsuspension."
              redirect_to [:admin, @account, :solus, @server]
            end
          end
        end
      end
    end
  end
end