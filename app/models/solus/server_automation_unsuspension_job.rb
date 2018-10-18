module Solus
  class ServerAutomationUnsuspensionJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_suspension_service = opts.fetch(:server_suspension_service) { ServerSuspensionService.new(server: server) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      server_suspension_service.unsuspend
    end

    private
    attr_accessor :server, :server_suspension_service
    delegate :account, to: :server
  end
end