module Users
  class InviteClaimer
    include Wisper::Publisher

    def initialize(opts = {})
      @user = opts.fetch(:user)
      @invite = opts.fetch(:invite)
      @event_logger = opts.fetch(:event_logger) { ::Accounts::EventLogger.new(account: account) }
    end

    def claim
      if create_membership && claim_invite
        Rails.logger.info { "User #{user.email} (#{user.id}) granted access to account #{account}"}

        event_logger.with_entity(invite).with_category(:security).log(:invite_claimed)

        publish(:claim_success, account)
      end
    end

    private
    attr_reader :user, :invite, :event_logger
    delegate :account, to: :invite

    def create_membership
      membership = account.memberships.find_or_create_by(user: user)

      invite.roles.each do |role|
        membership.roles << role
      end

      membership.save!
    end

    def claim_invite
      invite.claim!
    end
  end
end