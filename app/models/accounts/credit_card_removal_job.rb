module Accounts
  class CreditCardRemovalJob
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @stripe_card_service = opts.fetch(:stripe_card_service) { StripeCardService.new(account: account) }
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
    end

    def perform
      Rails.logger.info { "Fetched account #{account}" }

      stripe_card_service.delete
      event_logger.log(:credit_card_removed)
      mailer_service.credit_card_removed
    end

    private
    attr_accessor :account, :stripe_card_service, :event_logger, :mailer_service
  end
end