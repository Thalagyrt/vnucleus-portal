module Admin
  module Accounts
    module Solus
      module Servers
        class RebootsController < Admin::Accounts::Solus::Servers::ApplicationController
          before_filter :ensure_active

          def create
            if power_service.reboot
              flash[:notice] = "The server is now rebooting."
            end

            redirect_to [:admin, @account, :solus, @server]
          end

          private
          def power_service
            @power_service ||= ::Solus::ServerPowerService.new(server: @server, event_logger: account_event_logger)
          end

          def ensure_active
            unless @server.active?
              flash[:notice] = "This server is not in a state that allows power control."
              redirect_to [:admin, @account, :solus, @server]
            end
          end
        end
      end
    end
  end
end