module Tickets
  class UpdateCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @ticket = opts.fetch(:ticket)
      @user = opts.fetch(:user)
      @incident_policy = opts.fetch(:incident_policy) { IncidentPolicy.new(ticket: ticket, user: user) }
    end

    def create(params)
      @update = ticket.updates.new({priority: ticket.priority}.merge(params.merge(user: user)))

      if update.save
        ticket.update_attributes status: update.status, priority: update.priority, updated_at: update.created_at

        update_incident
        send_email
        send_notifications

        publish(:update_success)
      else
        publish(:update_failure, update)
      end
    end

    private
    attr_reader :ticket, :user, :update, :incident_policy
    delegate :account, to: :ticket

    def update_incident
      Delayed::Job.enqueue incident_policy.incident_job
    end

    def send_email
      mailer_services.each do |mailer_service|
        mailer_service.ticket_updated(update: update)
      end
    end

    def send_notifications
      notification_services.each do |notification_service|
        notification_service.ticket_updated(actor: user, target: ticket)
      end
    end

    def mailer_services
      [::Accounts::MailerService.new(account: account), ::Admin::MailerService.new]
    end

    def notification_services
      [::Accounts::NotificationService.new(account: account), ::Admin::NotificationService.new]
    end
  end
end