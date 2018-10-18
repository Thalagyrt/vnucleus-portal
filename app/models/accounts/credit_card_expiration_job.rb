module Accounts
  class CreditCardExpirationJob
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account, category: :billing) }
    end

    def perform
      Rails.logger.info { "Fetched account #{account}" }

      mailer_service.credit_card_expiring
      event_logger.log(:credit_card_expiration_notice)
    end

    def max_attempts
      1
    end

    private
    attr_reader :account, :mailer_service, :event_logger
  end
end