module Solus
  class NodeSynchronizationService
    def initialize(opts = {})
      @node = opts.fetch(:node)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
    end

    def synchronize
      Rails.logger.info { "Synchronizing node #{node}" }

      api_command('node-statistics', nodeid: node.name) do |response|
        node.update_attributes(
            hostname: response.hostname,
            ip_address: response.ip,
            node_group: response.nodegroupname,
            ram_limit: ram_limit(response),
            allocated_ram: allocated_ram(response),
            available_disk: available_disk(response),
            disk_limit: disk_limit(response),
            synchronized_at: Time.zone.now,
            available_ipv4: response.freeips,
            available_ipv6: response.freeipv6,
        )
      end
    end

    private
    attr_reader :node, :api_client
    delegate :api_command, to: :api_client
    delegate :cluster, to: :node

    def ram_limit(response)
      response.memorylimit.to_i.kilobytes
    end

    def allocated_ram(response)
      response.allocatedmemory.to_i.kilobytes
    end

    def available_disk(response)
      response.freedisk.to_i.kilobytes
    end

    def disk_limit(response)
      response.disklimit.to_i.kilobytes
    end
  end
end