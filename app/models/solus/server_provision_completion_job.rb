module Solus
  class ServerProvisionCompletionJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @completion_service = opts.fetch(:completion_service) { ServerProvisionCompletionService.new(server: server) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      completion_service.provision_complete
    end

    private
    attr_accessor :server, :completion_service
  end
end