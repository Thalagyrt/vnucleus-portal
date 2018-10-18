module Accounts
  class MailerService
    include ::Concerns::SimpleMailerServiceConcern

    define_mailers :ticket_created, :ticket_updated, :account_activated, :account_rejected

    define_mailers :server_confirmed, :server_provisioned, :server_suspended, :server_unsuspended, :server_terminated, :server_patched do |power|
      power.account_server_access?(account)
    end

    define_mailers :transactions_posted, :payment_received, :payment_failed, :transfer_notification, :credit_card_expiring, :new_credit_card_found, :credit_card_removed do |power|
      power.account_billing_access?(account)
    end

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @mailer = opts.fetch(:mailer) { Mailer }
    end

    private
    attr_reader :account, :mailer
    delegate :users, to: :account

    def merge_opts(user, opts = {})
      opts.merge(account: account, user: user)
    end
  end
end