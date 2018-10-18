module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class TerminationsController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            before_filter :lock_server
            before_filter :ensure_terminatable

            def create
              server_terminator.on(:terminate_success) do
                flash[:notice] = "Your server has been queued for termination."
                redirect_to [:users, @account, :solus, @server]
              end

              server_terminator.terminate(termination_params)
            end

            private
            def server_terminator
              @server_terminator ||= ::Solus::CreditingServerTerminator.new(server: @server, event_logger: account_event_logger, user: current_user)
            end

            def lock_server
              @server.lock!
            end

            def ensure_terminatable
              unless @server.can_schedule_termination?
                flash[:notice] = "This server is not in a state that allows termination."
                redirect_to [:users, @account, :solus, @server]
              end
            end

            def termination_params
              params.require(:server).permit(:termination_reason)
            end
          end
        end
      end
    end
  end
end