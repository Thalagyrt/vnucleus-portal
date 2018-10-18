module Solus
  class ServerAutomationSuspensionJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_suspension_service = opts.fetch(:server_suspension_service) { ServerSuspensionService.new(server: server) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      if server_suspension_service.automation_suspend
        server.update_attributes(suspend_on: nil, suspension_reason: :payment_not_received)
      end
    end

    private
    attr_accessor :server, :server_suspension_service
    delegate :account, to: :server
  end
end