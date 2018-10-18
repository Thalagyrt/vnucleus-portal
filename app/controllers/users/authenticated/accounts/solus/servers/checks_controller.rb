module Users
  module Authenticated
    module Accounts
      module Solus
        module Servers
          class ChecksController < ::Users::Authenticated::Accounts::Solus::Servers::ApplicationController
            power :account_solus_server_monitoring_checks, context: :load_server, as: :checks_scope

            before_filter :ensure_active

            decorates_assigned :check, :checks, :server

            def index
              render json: ChecksDatatable.new(checks_scope, view_context)
            end

            def new
              @check = checks_scope.new
            end

            def create
              @check = checks_scope.new(check_params)

              if @check.save
                flash[:notice] = "Your check has been added."

                redirect_to [:users, @account, :solus, @server]
              else
                render :new
              end
            end

            private
            def check_params
              params.require(:check).permit(:check_type, :check_data, :notify_account, :notify_after_failures)
            end

            def ensure_active
              unless @server.active?
                flash[:notice] = "This server is not in a state that allows monitoring."
                redirect_to [:users, @account, :solus, @server]
              end
            end
          end
        end
      end
    end
  end
end