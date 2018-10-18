module Accounts
  class InviteCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @user_mailer = opts.fetch(:user_mailer) { ::Users::Mailer }
    end

    def create(params)
      @invite = account.invites.new(params)

      if invite.save
        log_invitation
        send_email

        Rails.logger.info { "Invited #{invite.email} to account #{account}" }

        publish(:create_success, invite)
      else
        publish(:create_failure, invite)
      end
    end

    private
    attr_reader :account, :invite, :event_logger, :user_mailer

    def log_invitation
      event_logger.with_category(:security).with_entity(invite).log(:invite_sent)
    end

    def send_email
      user_mailer.delay.invite(invite: invite)
    end
  end
end