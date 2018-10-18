module Solus
  class ServerTerminator
    include Wisper::Publisher

    def initialize(opts = {})
      @server = opts.fetch(:server)
      @user = opts[:user]
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
      @server_termination_job = opts.fetch(:server_termination_job) { ServerTerminationJob.new(server: server) }
    end

    def terminate(params)
      server.with_lock do
        server.update_attributes(params.merge(state_event: :schedule_termination))
        log_termination
        send_notifications
        schedule_termination
        publish(:terminate_success)
      end
    end

    private
    attr_reader :server, :user, :event_logger, :server_termination_job
    delegate :account, to: :server

    def log_termination
      event_logger.with_entity(@server).with_category(:event).log(:server_termination_requested)
    end

    def schedule_termination
      Delayed::Job.enqueue server_termination_job
    end

    def send_notifications
      notification_services.each do |notification_service|
        notification_service.server_terminated(target: server, actor: user)
      end
    end

    def notification_services
      [::Admin::NotificationService.new]
    end
  end
end