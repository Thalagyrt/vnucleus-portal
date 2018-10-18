module Solus
  class ServiceLevelsController < ::ApplicationController
    decorates_assigned :plans

    def show
      @cluster = ::Solus::Cluster.find(params[:cluster_id])
    end
  end
end