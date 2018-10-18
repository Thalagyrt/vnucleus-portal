module Solus
  class ServerProvisionService
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @cluster_synchronization_job_class = opts.fetch(:cluster_synchronization_job_class) { ClusterSynchronizationJob }
      @usage_recorder_class = opts.fetch(:usage_recorder_class) { UsageRecorder }
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @string_generator = opts.fetch(:string_generator) { ::StringGenerator }
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @server_synchronization_job_class = opts.fetch(:server_synchronization_job_class) { ServerSynchronizationJob }
    end

    def provision
      server.with_lock do
        return false unless server.can_provision?

        with_client do
          provision_server
        end
      end
    end

    private
    attr_reader :server, :cluster_synchronization_job_class, :server_synchronization_job_class, :api_client, :string_generator, :event_logger, :usage_recorder_class
    delegate :api_command, to: :api_client
    delegate :cluster, :account, to: :server

    def with_client
      @username = string_generator.username

      api_command('client-create', client_options) do
        Rails.logger.info { "Created client #{@username}" }

        yield || begin
          Rails.logger.info { "Deleting client #{@username}" }

          api_command('client-delete', {username: @username})
          false
        end
      end
    end

    def client_options
      {
          username: @username,
          password: string_generator.password,
          firstname: "Account ##{server.account.to_param}",
          lastname: server.account.name,
          email: "noreply@vnucleus.com",
      }
    end

    def provision_server
      return unless select_node

      assign_root_password if generate_root_password?

      create_server
    end

    def select_node
      server.node = cluster.select_node(server.plan, server.template)

      Rails.logger.info { "Selected node #{server.node}" }

      server.node
    end

    def assign_root_password
      server.root_password = string_generator.password
    end

    def generate_root_password?
      server.template.generate_root_password?
    end

    def create_server
      api_command('vserver-create', vserver_options) do |response|
        Rails.logger.info { "Server provisioned. vserverid=#{response.vserverid} ipaddress=#{response.mainipaddress}" }

        update_server(response)
        log_provision

        record_usage

        synchronize_server
        synchronize_cluster

        true
      end
    end

    def vserver_options
      {
          username: @username,
          node: server.node.name,
          hostname: hostname,
          template: server.template_string,
          plan: server.plan_string,
          type: server.virtualization_type,
          ips: server.ip_addresses,
      }
    end

    def hostname
      if server.hostname =~ /\./
        server.hostname
      else
        "#{server.hostname[0..240]}.local"
      end
    end

    def update_server(response)
      options = { state_event: :provision, vserver_id: response.vserverid, ip_address: response.mainipaddress }
      options[:root_password] = response.rootpassword unless generate_root_password?

      server.update_attributes options
    end

    def log_provision
      event_logger.with_entity(server).with_category(:automation).log(:server_provisioned)
    end

    def synchronize_cluster
      Delayed::Job.enqueue cluster_synchronization_job_class.new(cluster: server.cluster)
    end

    def synchronize_server
      Delayed::Job.enqueue server_synchronization_job_class.new(server: server)
    end

    def record_usage
      usage_recorder_class.new(node: server.node, template: server.template).record
    end
  end
end