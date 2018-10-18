module Solus
  class ServerSuspensionService
    ACTIONS = {
        suspend: :server_suspended,
        unsuspend: :server_unsuspended
    }

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @api_client = opts.fetch(:api_client) { ApiClientService.new(cluster: cluster) }
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @mailer_service = opts.fetch(:mailer_service) { ::Accounts::MailerService.new(account: account ) }
    end

    def admin_suspend
      Rails.logger.info { "Suspending server #{server}" }

      execute(action: :suspend, state_event: :admin_suspend)
    end

    def automation_suspend
      Rails.logger.info { "Suspending server #{server}" }

      execute(action: :suspend, state_event: :automation_suspend)
    end

    def unsuspend
      Rails.logger.info { "Unsuspending server #{server}" }

      execute(action: :unsuspend) do
        server.update_attributes(suspension_reason: nil)
      end
    end

    private
    attr_reader :server, :api_client, :event_logger, :mailer_service
    delegate :api_command, to: :api_client
    delegate :cluster, :account, to: :server

    def execute(opts = {})
      action = opts.fetch(:action)
      state_event = opts.fetch(:state_event, action)

      server.with_lock do
        return false unless server.state_events.include? state_event

        api_command("vserver-#{action}", vserverid: server.vserver_id) do
          event_logger.with_entity(server).with_category(:event).log(ACTIONS[action])
          server.public_send(state_event)

          yield if block_given?

          mailer_service.public_send("server_#{action}ed", server: server)
        end
      end
    end
  end
end