module Admin
  module Solus
    class SynchronizationsController < Admin::ApplicationController
      power :admin_solus_clusters, as: :clusters_scope

      def create
        cluster = clusters_scope.find(params[:cluster_id])

        if Delayed::Job.enqueue ::Solus::ClusterSynchronizationJob.new(cluster: cluster)
          flash[:notice] = "The cluster has been scheduled for synchronization."
        end

        redirect_to [:admin, :solus, cluster]
      end
    end
  end
end