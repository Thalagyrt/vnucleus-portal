module Solus
  class ServerProvisionJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_provision_service = opts.fetch(:server_provision_service) { ServerProvisionService.new(server: server) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      if server_provision_service.provision
        if server.autocomplete_provision?
          Delayed::Job.enqueue ServerProvisionCompletionJob.new(server: server), run_at: Time.zone.now + 10.seconds
        else
          Delayed::Job.enqueue ServerProvisionCompletionCheckingJob.new(server: server, provision_id: server.provision_id), run_at: max_provision_time
        end
      end
    end

    def max_attempts
      5
    end

    private
    attr_reader :server, :server_provision_service
    delegate :install_time, to: :server

    def max_provision_time
      Time.zone.now + ((install_time * 1.2) + 8.minutes).to_i
    end
  end
end