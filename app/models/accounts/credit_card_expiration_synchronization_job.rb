module Accounts
  class CreditCardExpirationSynchronizationJob
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account, category: :billing) }
      @stripe_card_service = opts.fetch(:stripe_card_service) { StripeCardService.new(account: account) }
    end

    def perform
      Rails.logger.info { "Fetched account #{account}" }

      if new_expiration_date > Time.zone.today
        Rails.logger.info { "Found new expiration date: #{new_expiration_date}" }

        account.update_attributes stripe_expiration_date: new_expiration_date

        event_logger.log(:new_credit_card_found)
        mailer_service.new_credit_card_found
      else
        Rails.logger.info { "No new expiration date found" }

        stripe_card_service.delete

        event_logger.log(:credit_card_removed)
        mailer_service.credit_card_removed
      end
    end

    def max_attempts
      1
    end

    private
    attr_reader :account, :mailer_service, :event_logger, :stripe_card_service

    def new_expiration_date
      @new_expiration_date ||= Date.new(credit_card.expiration_year, credit_card.expiration_month, 1)
    end

    def credit_card
      @credit_card ||= stripe_card_service.fetch
    end
  end
end