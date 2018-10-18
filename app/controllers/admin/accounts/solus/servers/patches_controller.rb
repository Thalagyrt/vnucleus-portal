module Admin
  module Accounts
    module Solus
      module Servers
        class PatchesController < Admin::Accounts::Solus::Servers::ApplicationController
          before_filter :ensure_active
          before_filter :ensure_patches_due

          def create
            server_patcher = ::Solus::ServerPatcher.new(server: @server, event_logger: account_event_logger)

            server_patcher.on(:patch_success) do
              flash[:notice] = "The server has been marked as patched."
              redirect_to [:admin, @account, :solus, @server]
            end

            server_patcher.on(:patch_failure) do
              flash[:alert] = "The server was unable to be marked as patched."
              redirect_to [:admin, @account, :solus, @server]
            end

            server_patcher.patch
          end

          private
          def ensure_active
            unless @server.active?
              flash[:notice] = "This server is not in a state that allows patching."
              redirect_to [:admin, @account, :solus, @server]
            end
          end

          def ensure_patches_due
            unless @server.patches_due?
              flash[:notice] = "This server is not in a state that allows patching."
              redirect_to [:admin, @account, :solus, @server]
            end
          end
        end
      end
    end
  end
end