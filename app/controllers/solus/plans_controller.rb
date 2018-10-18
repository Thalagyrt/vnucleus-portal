module Solus
  class PlansController < ::ApplicationController
    decorates_assigned :plans

    power :user_solus_cluster_plans, context: :cluster, as: :plans_scope

    def show
      plans = plans_scope.sorted

      if params[:managed].present?
        plans = plans.where(managed: params[:managed])
      end

      @plans = plans.select do |plan|
        cluster.select_node(plan).present?
      end
    end

    private
    def cluster
      @cluster ||= ::Solus::Cluster.find(params[:cluster_id])
    end
  end
end