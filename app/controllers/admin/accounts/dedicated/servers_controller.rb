module Admin
  module Accounts
    module Dedicated
      class ServersController < Admin::Accounts::ApplicationController
        decorates_assigned :server, :servers

        power :admin_account_dedicated_servers, context: :load_account, as: :servers_scope

        def index
          @servers = servers_scope
          @servers = @servers.find_current unless params[:show_all].present?
        end

        def show
          @server = servers_scope.includes(events: [:user]).find_by_param(params[:id])

          ::Users::Notification.where(user: current_user, target: @server).mark_all_read
        end

        def edit
          @server = servers_scope.find_by_param(params[:id])
        end

        def update
          @server = servers_scope.find_by_param(params[:id])

          if @server.update_attributes(server_params)
            account_event_logger.with_entity(@server).with_category(:event).log(:server_details_updated)
            flash[:notice] = 'The server has been updated.'
            redirect_to [:admin, @account, :dedicated, @server]
          else
            render :edit
          end
        end

        private
        def server_params
          params.require(:server).permit(
              :hostname, :amount_dollars, :root_password, :suspend_on, :terminate_on,
              :state, :next_due,  :patch_at, :patch_period, :patch_period_unit, :patch_out_of_band,
          )
        end
      end
    end
  end
end