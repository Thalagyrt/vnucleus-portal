module Tickets
  class TicketCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @user = opts.fetch(:user)
      @incident_policy_class = opts.fetch(:incident_policy_class) { IncidentPolicy }
    end

    def create(params)
      @ticket_form = Tickets::TicketForm.new(params)

      if ticket_form.valid?
        @ticket = account.tickets.create(subject: ticket_form.subject, priority: ticket_form.priority)
        ticket.updates.create(user: user, body: ticket_form.body, secure_body: ticket_form.secure_body, priority: ticket_form.priority)
        update_incident

        account.complete_welcome
        send_email
        send_notifications

        publish(:create_success, ticket)
      else
        publish(:create_failure, ticket_form)
      end
    end

    private
    attr_reader :account, :user, :ticket, :ticket_form, :incident_policy_class

    def update_incident
      Delayed::Job.enqueue incident_policy.incident_job
    end

    def send_email
      mailer_services.each do |mailer_service|
        mailer_service.ticket_created(ticket: ticket)
      end
    end

    def send_notifications
      notification_services.each do |notification_service|
        notification_service.ticket_created(actor: user, target: ticket)
      end
    end

    def incident_policy
      incident_policy_class.new(ticket: ticket, user: user)
    end

    def mailer_services
      [::Accounts::MailerService.new(account: account), ::Admin::MailerService.new]
    end

    def notification_services
      [::Accounts::NotificationService.new(account: account), ::Admin::NotificationService.new]
    end
  end
end