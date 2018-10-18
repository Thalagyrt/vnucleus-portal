module Solus
  class StatusService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @status_class = opts.fetch(:status_class) { Status }
    end

    def status
      @status ||= begin
        Rails.logger.info { "Fetching status for server #{server}" }

        basic_info = api_client.api_command('vserver-info', vserverid: server.vserver_id)
        detailed_info = api_client.api_command('vserver-infoall', vserverid: server.vserver_id)

        ip_addresses = detailed_info.ipaddresses.split(',').map(&:strip)
        total_transfer, used_transfer, _, _ = detailed_info.bandwidth.split(',').map(&:to_i)
        total_disk, _, _, _ = detailed_info.hdd.split(',').map(&:to_i)

        status_class.new(
            ip_addresses: ip_addresses,
            power_state: detailed_info.state,
            total_transfer: total_transfer,
            used_transfer: used_transfer,
            total_disk: total_disk,
            node: detailed_info.node,
            xen_id: basic_info.ctid_xid,
        )
      end
    end

    private
    attr_reader :server, :api_client, :status_class
    delegate :cluster, to: :server
  end
end