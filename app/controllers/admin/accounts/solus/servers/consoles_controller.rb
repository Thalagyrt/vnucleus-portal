module Admin
  module Accounts
    module Solus
      module Servers
        class ConsolesController < Accounts::Solus::Servers::ApplicationController
          layout 'console'

          decorates_assigned :console_requested_by, :server

          before_filter :ensure_active

          def show
            respond_to do |format|
              format.js
              format.html do
                if @server.lock_console_for!(current_user)
                  @console = console_service.console

                  account_event_logger.with_entity(@server).with_category(:access).log(:server_console_opened)
                  ::Solus::ConsoleSession.target(request.remote_ip, @console.hostname, @console.port)
                else
                  render :locked
                end
              end
            end
          end

          def update
            if @server.console_heartbeat!(params[:lock_id])
              if @server.console_requested_by.present?
                @console_requested_by = @server.console_requested_by
                @server.update_attributes console_requested_by: nil
              end

              render status: :ok
            else
              head status: :not_found
            end
          end

          def destroy
            if @server.console_locked?
              @server.request_console_for!(current_user)
            end
          end

          private
          def console_service
            ::Solus::ConsoleService.new(server: server)
          end

          def ensure_active
            unless @server.active? || @server.pending_completion?
              flash[:notice] = "This server is not in a state that allows console access"
              redirect_to [:admin, @account, :solus, @server]
            end
          end
        end
      end
    end
  end
end