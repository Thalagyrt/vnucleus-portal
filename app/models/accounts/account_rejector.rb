module Accounts
  class AccountRejector
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @stripe_card_service = opts.fetch(:stripe_card_service) { StripeCardService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
    end

    def reject
      Rails.logger.info { "Rejecting account #{account}" }

      account.with_lock do
        return fail! if provisioning_servers?
        return fail! unless account.can_reject?

        cancel_orders
        terminate_servers
        close_tickets
        delete_credit_card
        ban_users
        reject_account
        mailer_service.account_rejected

        event_logger.log(:account_rejected)

        publish :reject_success
      end
    end

    private
    attr_accessor :account, :stripe_card_service, :event_logger, :mailer_service

    def provisioning_servers?
      account.current_solus_servers.any?(&:provisioning?)
    end

    def cancel_orders
      account.pending_solus_servers.each do |server|
        server.cancel_order!
      end
    end

    def terminate_servers
      account.current_solus_servers.each do |server|
        server.reject!
        Delayed::Job.enqueue ::Solus::ServerTerminationJob.new(server: server)
      end
    end

    def close_tickets
      account.open_tickets.each do |ticket|
        ticket.update_attributes status: :closed
        Delayed::Job.enqueue ::Tickets::ResolveIncidentJob.new(ticket: ticket)
      end
    end


    def ban_users
      account.users.each do |user|
        user.ban!
      end
    end

    def delete_credit_card
      stripe_card_service.delete
    end

    def reject_account
      account.reject!
    end

    def fail!
      publish :reject_failure
    end
  end
end