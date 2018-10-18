module Solus
  class ServerPowerService
    ACTIONS = {
        boot: :server_booted,
        reboot: :server_rebooted,
        shutdown: :server_shut_down
    }

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
    end

    def shutdown
      Rails.logger.info { "Shutting down server #{server}" }

      server.monitoring_disable

      execute(:shutdown)
    end

    def boot
      Rails.logger.info { "Booting server #{server}" }

      server.monitoring_reset

      execute(:boot)
    end

    def reboot
      Rails.logger.info { "Rebooting server #{server}" }

      server.monitoring_reboot

      execute(:reboot)
    end

    private
    attr_reader :server, :api_client, :event_logger
    delegate :api_command, to: :api_client
    delegate :cluster, :account, to: :server

    def execute(action)
      api_command("vserver-#{action}", vserverid: server.vserver_id) do
        event_logger.with_entity(server).with_category(:event).log(ACTIONS[action])
      end
    end
  end
end