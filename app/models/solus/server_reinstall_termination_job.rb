module Solus
  class ServerReinstallTerminationJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_termination_service = opts.fetch(:server_termination_service) { ServerTerminationService.new(server: server) }
      @server_provision_job_class = opts.fetch(:server_provision_job_class) { ServerProvisionJob }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      if server_termination_service.terminate
        Rails.logger.info { "Scheduling provision of new server" }

        Delayed::Job.enqueue server_provision_job_class.new(server: server), run_at: Time.zone.now + 60.seconds
      end
    end

    private
    attr_reader :server, :server_termination_service, :server_provision_job_class
    delegate :account, to: :server
  end
end