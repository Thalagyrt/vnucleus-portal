module Accounts
  class AutomationService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @server_provision_job_class = opts.fetch(:server_provision_job_class) { ::Solus::ServerProvisionJob }

      @server_unsuspension_job_class = opts.fetch(:server_unsuspension_job_class) { ::Solus::ServerAutomationUnsuspensionJob }
      @server_suspension_job_class = opts.fetch(:server_suspension_job_class) { ::Solus::ServerAutomationSuspensionJob }
      @server_termination_job_class = opts.fetch(:server_suspension_job_class) { ::Solus::ServerAutomationTerminationJob }

      @mailer_service = opts.fetch(:mailer_service) { ::Admin::MailerService.new }
    end

    def in_favor
      Rails.logger.info { "Account #{account} is in favor" }

      clear_automation
      mark_servers_paid
      schedule_pending_provisions
      schedule_unsuspensions
    end

    def out_of_favor
      Rails.logger.info { "Account #{account} is out of favor" }

      set_automation
      schedule_suspensions
    end

    def close_account
      Rails.logger.info { "Closing account #{account}" }

      account.close!
      schedule_terminations
    end

    private
    attr_reader :account, :server_provision_job_class, :server_unsuspension_job_class, :mailer_service,
                :server_suspension_job_class, :server_termination_job_class

    def set_automation
      account.update_attributes close_on: termination_date unless account.close_on.present?

      account.solus_servers.find_current.where(suspend_on: nil).update_all suspend_on: suspension_date
      account.solus_servers.find_current.where(terminate_on: nil).update_all terminate_on: termination_date

      account.dedicated_servers.find_current.where(suspend_on: nil).update_all suspend_on: suspension_date
      account.dedicated_servers.find_current.where(terminate_on: nil).update_all terminate_on: termination_date
    end

    def suspension_date
      Time.zone.today + Rails.application.config.automation[:suspend_after]
    end

    def termination_date
      Time.zone.today + Rails.application.config.automation[:terminate_after]
    end

    def clear_automation
      account.update_attributes close_on: nil
      account.solus_servers.find_current.update_all suspend_on: nil, terminate_on: nil
      account.dedicated_servers.find_current.update_all suspend_on: nil, terminate_on: nil
    end

    def mark_servers_paid
      account.solus_servers_pending_payment.each do |server|
        server.paid
      end
    end

    def schedule_pending_provisions
      account.solus_servers_pending_provision.each do |server|
        Delayed::Job.enqueue server_provision_job_class.new(server: server)
      end
    end

    def schedule_unsuspensions
      account.automation_suspended_solus_servers.each do |server|
        Delayed::Job.enqueue server_unsuspension_job_class.new(server: server)
      end
    end

    def schedule_suspensions
      account.solus_servers.find_automation_suspendible.find_each do |server|
        Delayed::Job.enqueue server_suspension_job_class.new(server: server)
      end

      account.dedicated_servers.find_automation_suspendible.find_each do |server|
        server.schedule_automation_suspension!
      end
    end

    def schedule_terminations
      account.solus_servers.find_current.find_each do |server|
        Delayed::Job.enqueue server_termination_job_class.new(server: server)
      end

      account.dedicated_servers.find_current.find_each do |server|
        server.schedule_automation_termination!
      end
    end
  end
end