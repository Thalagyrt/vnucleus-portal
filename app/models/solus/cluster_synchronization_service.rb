module Solus
  class ClusterSynchronizationService
    def initialize(opts = {})
      @cluster = opts.fetch(:cluster)
      @node_synchronization_service_klass = opts.fetch(:node_synchronization_service_class) { NodeSynchronizationService }
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
    end

    def synchronize
      Rails.logger.info { "Synchronizing cluster #{cluster}" }

      xen_nodes = api_command('listnodes', type: 'xen').nodes.split(',')
      kvm_nodes = api_command('listnodes', type: 'kvm').nodes.split(',')

      solus_nodes = (xen_nodes + kvm_nodes).uniq

      cluster.prune_nodes(solus_nodes)

      solus_nodes.each do |node_name|
        @node_synchronization_service_klass.new(node: cluster.get_node(node_name)).synchronize
      end

      cluster.update_attributes synchronized_at: Time.zone.now
    end

    private
    attr_reader :cluster, :api_client
    delegate :api_command, to: :api_client
  end
end