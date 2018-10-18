module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class ReinstallsController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            before_filter :ensure_active

            def new
              @reinstall_form = ::Solus::ReinstallForm.new(server: @server, template_id: @server.template_id)
            end

            def create
              server_reinstaller = ::Solus::ServerReinstaller.new(server: @server, account_event_logger: account_event_logger)

              server_reinstaller.on(:reinstall_success) do
                flash[:notice] = "Your server is being reinstalled."
                redirect_to [:users, @account, :solus, @server]
              end
              server_reinstaller.on(:reinstall_failure) do |reinstall_form|
                @reinstall_form = reinstall_form
                render :new
              end

              server_reinstaller.reinstall(reinstall_form_params)
            end

            private
            def ensure_active
              unless @server.reinstallable?
                flash[:notice] = "This server is not in a state that allows reinstall."
                redirect_to [:users, @account, :solus, @server]
              end
            end

            def reinstall_form_params
              params.require(:reinstall_form).permit(:template_id)
            end
          end
        end
      end
    end
  end
end