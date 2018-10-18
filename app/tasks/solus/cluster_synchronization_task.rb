module Solus
  class ClusterSynchronizationTask < DelayedSchedulerTask
    environments :all

    cron '0 * * * *'

    def perform
      ::Solus::Cluster.find_each do |cluster|
        Delayed::Job.enqueue ::Solus::ClusterSynchronizationJob.new(cluster: cluster)
      end
    end
  end
end