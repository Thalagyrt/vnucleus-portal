module Admin
  class Mailer < ActionMailer::Base
    default from: '"vNucleus" <noreply@vnucleus.com>'

    def ticket_created(opts)
      @user = opts.fetch(:user)
      @ticket = opts.fetch(:ticket).decorate
      @update = @ticket.updates.first
      @account = @ticket.account

      mail(to: @user.email, subject: "[#{@ticket.to_param}] #{@ticket.subject}")
    end

    def ticket_updated(opts)
      @user = opts.fetch(:user)
      @update = opts.fetch(:update).decorate
      @ticket = @update.ticket
      @account = @ticket.account

      mail(to: @user.email, subject: "Re: [#{@ticket.to_param}] #{@ticket.subject}")
    end

    def server_confirmed(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = @server.account

      mail(to: @user.email, subject: "New Order: Server #{@server.to_s}")
    end

    def server_terminated(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = @server.account

      mail(to: @user.email, subject: "Server Terminated: Server #{@server.to_s}")
    end

    def provision_stalled(opts)
      @user = opts.fetch(:user)
      @server = opts.fetch(:server).decorate
      @account = @server.account

      mail(to: @user.email, subject: "Provision Stalled: Server #{@server.to_s}")
    end

    def login_failed(opts)
      @user = opts.fetch(:user)
      @failed_user = opts.fetch(:failed_user)
      @ip_address = opts.fetch(:ip_address)

      mail(to: @user.email, subject: "Failed login for #{@failed_user.email} from #{@ip_address}")
    end

    def account_pending_activation(opts)
      @user = opts.fetch(:user)
      @account = opts.fetch(:account).decorate

      mail(to: @user.email, subject: "Account pending manual activation")
    end

    def lead_captured(opts)
      @user = opts.fetch(:user)
      @lead = opts.fetch(:lead)

      mail(to: @user.email, subject: "New Lead Captured")
    end
  end
end