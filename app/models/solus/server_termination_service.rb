module Solus
  class ServerTerminationService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @cluster_synchronization_job = opts.fetch(:cluster_synchronization_job) { ClusterSynchronizationJob.new(cluster: cluster) }
      @usage_updater_job = opts.fetch(:usage_updater_job) { UsageUpdaterJob.new }
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @reverse_dns_updater_class = opts.fetch(:reverse_dns_updater_class) { ReverseDnsUpdater }
      @assignment_klass = opts.fetch(:assignment_klass) { IpHistory::Assignment }
    end

    def terminate
      options = {
          vserverid: server.vserver_id,
          deleteclient: true
      }

      server.with_lock do
        return false unless server.can_terminate?

        Rails.logger.info { "Terminating server #{server}" }

        if api_command('vserver-checkexists', options)
          api_command('vserver-terminate', options) do
            finalize_termination
          end
        else
          Rails.logger.info { "Server already terminated - cleaning up" }

          finalize_termination
        end
      end
    end

    private
    attr_reader :server, :cluster_synchronization_job, :api_client, :event_logger, :usage_updater_job, :reverse_dns_updater_class, :assignment_klass
    delegate :api_command, to: :api_client
    delegate :cluster, :node, :account, :ip_address_list, to: :server

    def finalize_termination
      ip_address_list.each do |ip_address|
        assignment_klass.record_usage(server, ip_address)

        updater = reverse_dns_updater_class.new(ip_address: ip_address)

        if updater.has_mapping?
          updater.destroy

          # AWS has a rate limit of 5 requests/sec. Let's be extra careful in case multiple terminations are happening.
          # Nobody's gonna care that a termination takes a while.
          updater.rate_limit_sleep
        end
      end

      server.vserver_id = nil
      server.node = nil
      server.root_password = nil
      server.xen_id = nil

      server.monitoring_disable

      server.terminate

      event_logger.with_entity(server).with_category(:automation).log(:server_terminated)

      Delayed::Job.enqueue cluster_synchronization_job
      Delayed::Job.enqueue usage_updater_job

      true
    end
  end
end