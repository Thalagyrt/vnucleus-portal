module Solus
  class ServerAutomationTerminationJob
    def initialize(opts = {})
      @server = opts.fetch(:server)
      @server_termination_job = opts.fetch(:server_termination_job) { ServerTerminationJob.new(server: server) }
    end

    def perform
      Rails.logger.info { "Fetched server #{server}" }

      if server.update_attributes(terminate_on: nil, termination_reason: :payment_not_received, state_event: :schedule_automation_termination)
        Rails.logger.info { "Scheduling termination of server #{server}" }

        Delayed::Job.enqueue server_termination_job
      end
    end

    private
    attr_accessor :server, :server_termination_job
    delegate :account, to: :server
  end
end