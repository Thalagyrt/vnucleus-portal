module Accounts
  class Mailer < ActionMailer::Base
    default from: '"vNucleus" <noreply@vnucleus.com>'

    def ticket_created(opts)
      @user = opts.fetch(:user)
      @ticket = opts.fetch(:ticket).decorate
      @update = @ticket.updates.first

      mail(to: @user.email, subject: "[#{@ticket.to_param}] #{@ticket.subject}")
    end

    def ticket_updated(opts)
      @user = opts.fetch(:user)
      @update = opts.fetch(:update).decorate
      @ticket = @update.ticket

      mail(to: @user.email, subject: "Re: [#{@ticket.to_param}] #{@ticket.subject}")
    end

    def server_confirmed(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Your order confirmation for server #{@server.to_s}")
    end

    def server_provisioned(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} has been provisioned")
    end

    def server_patched(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} has been patched")
    end

    def server_suspended(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} has been suspended")
    end

    def server_unsuspended(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} has been unsuspended")
    end

    def server_terminated(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} has been terminated")
    end

    def transactions_posted(opts)
      @user = opts.fetch(:user)
      @transactions = opts.fetch(:transactions).map { |t| t.decorate }
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "New transactions have posted to your account")
    end

    def payment_received(opts)
      @user = opts.fetch(:user)
      @transaction = opts.fetch(:transaction).decorate
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Thank you for your payment!")
    end

    def payment_failed(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate
      @amount = MoneyFormatter.format_amount(opts.fetch(:amount))

      mail(to: @user.email, subject: "A recent payment on your account has failed")
    end

    def credit_card_expiring(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Your credit card is expiring soon")
    end

    def new_credit_card_found(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "We've updated your credit card")
    end

    def credit_card_removed(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Your credit card has been removed")
    end

    def account_activated(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Your account has been activated")
    end

    def account_rejected(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Your account could not be activated")
    end

    def transfer_notification(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = opts.fetch(:account)

      mail(to: @user.email, subject: "Server #{@server.to_s} is approaching its bandwidth limit")
    end
  end
end