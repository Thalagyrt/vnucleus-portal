module Admin
  module Solus
    class ClustersController < Admin::ApplicationController
      power :admin_solus_clusters, as: :clusters_scope

      decorates_assigned :clusters, :cluster

      def index
        @clusters = clusters_scope
      end

      def show
        @cluster = clusters_scope.find(params[:id])
      end
    end
  end
end