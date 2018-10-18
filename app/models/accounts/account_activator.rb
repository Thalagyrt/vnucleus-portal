module Accounts
  class AccountActivator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
    end

    def activate
      account.activate!

      event_logger.with_category(:event).log(:account_activated)
      mailer_service.account_activated

      publish(:activate_success)
    end

    private
    attr_reader :account, :user, :event_logger, :mailer_service
  end
end