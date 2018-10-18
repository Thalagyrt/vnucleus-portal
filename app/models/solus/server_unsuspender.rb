module Solus
  class ServerUnsuspender
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @suspension_service = opts.fetch(:suspension_service) { ServerSuspensionService.new(server: server, event_logger: event_logger) }
    end

    def unsuspend
      suspension_service.unsuspend

      publish(:unsuspend_success)
    end

    private
    attr_reader :server, :suspension_service, :event_logger
    delegate :account, to: :server
  end
end