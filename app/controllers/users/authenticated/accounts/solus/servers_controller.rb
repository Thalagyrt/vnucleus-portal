module Users
  module Authenticated
    module Accounts
      module Solus
        class ServersController < ::Users::Authenticated::Accounts::ApplicationController
          power :account_solus_servers, context: :load_account, as: :servers_scope, map: { [:new, :create] => :creatable_account_solus_servers }

          decorates_assigned :server, :servers, :plans, :templates, :clusters

          def index
            @servers = servers_scope.includes(:plan, :template, :cluster, :node)
            @servers = @servers.find_current unless params[:show_all].present?
          end

          def show
            @server = servers_scope.includes(events: [:user]).find_by_param(params[:id])

            ::Users::Notification.where(user: current_user, target: @server).mark_all_read
            
            if server.can_confirm?
              redirect_to [:new, :users, @account, :solus, @server, :confirmations]
            end
          end

          def new
            @clusters = ::Solus::Cluster.all

            @server_form = ::Solus::ServerForm.new(coupon_code: cookies[:coupon_code], current_power: current_power)
          end

          def create
            server_creator = ::Solus::ServerCreator.new(account: account, server_factory: servers_scope)

            server_creator.on(:create_success) do |server|
              redirect_to [:new, :users, @account, :solus, server, :confirmations]
            end
            server_creator.on(:create_failure) do |server_form|
              @clusters = ::Solus::Cluster.all

              @server_form = server_form
              render :new
            end

            server_creator.create(server_form_params)
          end

          private
          def server_form_params
            params.require(:server_form).permit(:hostname, :cluster_id, :plan_id, :template_id, :coupon_code).merge(current_power: current_power)
          end
        end
      end
    end
  end
end