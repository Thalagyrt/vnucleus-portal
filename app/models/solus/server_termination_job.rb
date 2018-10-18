module Solus
  class ServerTerminationJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_termination_service = opts.fetch(:server_termination_service) { ServerTerminationService.new(server: server) }
      @mailer_service = opts.fetch(:mailer_service) { ::Accounts::MailerService.new(account: account) }
      @admin_mailer_service = opts.fetch(:admin_mailer_service) { ::Admin::MailerService.new(account: account) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      if server_termination_service.terminate
        mailer_service.server_terminated(server: server)
        admin_mailer_service.server_terminated(server: server)
      end
    end

    private
    attr_reader :server, :server_termination_service, :mailer_service, :admin_mailer_service
    delegate :account, to: :server
  end
end