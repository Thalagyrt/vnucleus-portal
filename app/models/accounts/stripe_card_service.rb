module Accounts
  class StripeCardService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @stripe_customer_service = opts.fetch(:stripe_customer_service) { StripeCustomerService.new(account: account) }
      @error_message = nil
    end

    def delete
      Rails.logger.info { "Removing credit card from account #{account}" }

      stripe_customer.cards.each(&:delete)

      account.update_attributes stripe_valid: false, stripe_expiration_date: nil
    end

    def save(credit_card)
      Rails.logger.info { "Saving credit card to account #{account}" }

      stripe_customer.card = credit_card.token
      begin
        stripe_customer.save

        account.update_attributes account_params(credit_card)

        Rails.logger.info { "Success!" }

        true
      rescue Stripe::CardError => e
        @error_message = e.message

        Rails.logger.info { "Failure: #{e.message}" }

        false
      rescue Stripe::StripeError => e
        Airbrake.notify_or_ignore(e)

        @error_message = e.message

        Rails.logger.error { "Failure: #{e.message}" }
        e.backtrace.each { |line| Rails.logger.error line }

        false
      end
    end

    def fetch
      credit_card_data = stripe_customer.active_card
      return nil if credit_card_data.nil?

      CreditCard.from_card(credit_card_data)
    end

    attr_reader :error_message

    private
    attr_reader :account, :stripe_customer_service
    delegate :stripe_customer, to: :stripe_customer_service

    def account_params(credit_card)
      {
          stripe_valid: true,
          address_line1: credit_card.address_line1,
          address_line2: credit_card.address_line2,
          address_city: credit_card.address_city,
          address_state: credit_card.address_state,
          address_zip: credit_card.address_zip,
          address_country: credit_card.address_country,
          stripe_expiration_date: credit_card.expiration_date,
          credit_card_updated_at: Time.zone.now
      }
    end
  end
end