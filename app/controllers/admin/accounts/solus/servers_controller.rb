module Admin
  module Accounts
    module Solus
      class ServersController < Admin::Accounts::ApplicationController
        decorates_assigned :server, :servers, :plans, :templates, :clusters

        power :admin_account_solus_servers, context: :load_account, as: :servers_scope, map: { [:new, :create] => :creatable_admin_account_solus_servers, [:edit, :update] => :updatable_admin_account_solus_servers }

        def index
          @servers = servers_scope.includes(:plan, :template, :cluster, :node)
          @servers = @servers.find_current unless params[:show_all].present?
        end

        def show
          @server = servers_scope.includes(events: [:user]).find_by_param(params[:id])

          ::Users::Notification.where(user: current_user, target: @server).mark_all_read
        end

        def edit
          @clusters = ::Solus::Cluster.all
          @plans = ::Solus::Plan.all
          @templates = ::Solus::Template.all
          @backup_users = @account.backup_users

          @server = servers_scope.find_by_param(params[:id])
        end

        def update
          @server = servers_scope.find_by_param(params[:id])

          if @server.update_attributes(server_params)
            if @server.active?
              Delayed::Job.enqueue ::Solus::ServerSynchronizationJob.new(server: @server)
            end

            account_event_logger.with_entity(@server).with_category(:event).log(:server_details_updated)
            flash[:notice] = 'The server has been updated.'
            redirect_to [:admin, @account, :solus, @server]
          else
            @clusters = ::Solus::Cluster.all
            @plans = ::Solus::Plan.all
            @templates = ::Solus::Template.all

            render :edit
          end
        end

        def new
          @clusters = ::Solus::Cluster.all

          @server_form = ::Solus::ServerForm.new(current_power: current_power)
        end

        def create
          server_creator = ::Solus::ServerCreator.new(account: account, server_factory: servers_scope)

          server_creator.on(:create_success) do |server|
            redirect_to [:admin, @account, :solus, server]
          end

          server_creator.on(:create_failure) do |server_form|
            @clusters = ::Solus::Cluster.all
            @plans = ::Solus::Plan.active
            @templates = ::Solus::Template.active

            @server_form = server_form
            render :new
          end

          server_creator.create(server_form_params)
        end

        private
        def server_params
          params.require(:server).permit(
              :hostname, :plan_amount_dollars, :template_amount_dollars, :root_password, :suspend_on, :terminate_on,
              :plan_id, :template_id, :cluster_id, :vserver_id, :state, :next_due, :transfer_tb,
              :patch_at, :patch_period, :patch_period_unit, :patch_out_of_band, :backup_user_id, :enable_smtp, :bypass_firewall
          )
        end

        def server_form_params
          params.require(:server_form).permit(:hostname, :cluster_id, :plan_id, :template_id, :coupon_code).merge(current_power: current_power)
        end
      end
    end
  end
end