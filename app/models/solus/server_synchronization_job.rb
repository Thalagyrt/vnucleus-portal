module Solus
  class ServerSynchronizationJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @status_service = opts.fetch(:status_service) { StatusService.new(server: server) }
      @assignment_klass = opts.fetch(:assignment_klass) { IpHistory::Assignment }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      server.with_lock do
        return unless server.active? || server.provisioning?

        update_server
        record_ip_usage
        reschedule_synchronization
        server.save!
      end
    end

    private
    attr_reader :server, :status_service, :assignment_klass
    delegate :status, to: :status_service

    def update_server
      node = Node.find_by_name(status.node)

      if node
        server.node = node
      end

      server.ip_address_list = status.ip_addresses
      server.ip_address = status.ip_addresses.first
      server.disk = status.total_disk
      server.used_transfer = status.used_transfer if status.used_transfer > server.used_transfer
      server.xen_id = status.xen_id
      server.synchronized_at = Time.zone.now
    end

    def record_ip_usage
      server.ip_address_list.each do |ip_address|
        assignment_klass.record_usage(server, ip_address)
      end
    end

    def reschedule_synchronization
      server.synchronize_at = next_synchronization

      Rails.logger.info { "Next synchronization at #{server.synchronize_at}" }
    end

    def next_synchronization
      Time.zone.now.at_beginning_of_hour + rand(4..12) * 15.minutes
    end
  end
end