module Accounts
  class CreditCardUpdater
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @user = opts.fetch(:user)
      @request = opts.fetch(:request)
      @stripe_card_service = opts.fetch(:stripe_card_service) { StripeCardService.new(account: account) }
      @payment_service = opts.fetch(:payment_service) { PaymentService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @account_activation_service_class = opts.fetch(:account_activation_service_class) { MaxmindActivationService }
    end

    def update(params)
      @credit_card = Accounts::CreditCard.new(params)

      if credit_card.valid?
        if stripe_card_service.save(credit_card)
          event_logger.with_category(:billing).log(:credit_card_updated)

          billing_information_entered if account.pending_billing_information?
          activate_account if account.pending_activation?

          payment_service.charge_balance
          return publish(:update_success)
        else
          credit_card.errors[:number] << (stripe_card_service.error_message || "something went wrong")
        end
      end

      publish(:update_failure, credit_card)

    rescue Stripe::CardError => e
      Airbrake.notify_or_ignore(e)

      credit_card.errors[:number] << e.message

      publish(:update_failure, credit_card)
    end

    private
    attr_reader :account, :user, :request, :stripe_card_service, :payment_service, :event_logger, :credit_card, :account_activation_service_class

    def billing_information_entered
      account.billing_information_entered
    end

    def activate_account
      account_activation_service.activate
    end

    def account_activation_service
      @account_activation_service ||= account_activation_service_class.new(account: account, user: user, request: request)
    end
  end
end