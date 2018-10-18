module Admin
  module Solus
    class PlansController < Admin::ApplicationController
      power :admin_solus_plans, as: :plans_scope

      decorates_assigned :plans, :plan

      def index
        @plans = plans_scope
        @plans = @plans.active unless params[:show_all].present?
      end

      def new
        @plan = plans_scope.new
      end

      def create
        @plan = plans_scope.new(plan_params)

        if @plan.save
          flash[:notice] = 'The plan has been saved.'
          redirect_to [:admin, :solus, :plans]
        else
          render :new
        end
      end

      def edit
        @plan = plans_scope.find(params[:id])
      end

      def update
        @plan = plans_scope.find(params[:id])

        if @plan.update_attributes(plan_params)
          flash[:notice] = 'The plan has been updated.'
          redirect_to [:admin, :solus, :plans]
        else
          render :edit
        end
      end

      private
      def plan_params
        params.require(:plan).permit(
            :name, :ram_mb, :ram, :disk_gb, :disk, :disk_type, :transfer_tb, :transfer, :network_out,
            :ip_addresses, :ipv6_addresses, :vcpus, :plan_part, :node_group, :status, :feature_status,
            :amount, :amount_dollars, :managed, :template_ids => [], :cluster_ids => []
        )
      end
    end
  end
end