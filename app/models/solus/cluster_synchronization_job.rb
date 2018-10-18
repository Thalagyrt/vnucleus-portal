module Solus
  class ClusterSynchronizationJob
    def initialize(opts = {})
      @cluster = opts.fetch(:cluster)
      @cluster_synchronization_service = opts.fetch(:cluster_synchronization_service) { ClusterSynchronizationService.new(cluster: cluster) }
    end

    def perform
      cluster_synchronization_service.synchronize
    end

    private
    attr_reader :cluster, :cluster_synchronization_service
  end
end