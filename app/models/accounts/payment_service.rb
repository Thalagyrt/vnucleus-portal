module Accounts
  class PaymentService
    def initialize(opts = {})
      @account = opts.fetch(:account)
      @mailer_service = opts.fetch(:mailer_service) { MailerService.new(account: account) }
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account, category: :billing) }
      @automation_service = opts.fetch(:automation_service) { AutomationService.new(account: account) }
    end

    def charge_balance
      account.with_lock do
        charge(account.balance) unless account.balance_favorable?
      end
    end

    def charge(amount)
      Rails.logger.info { "Processing payment of #{MoneyFormatter.format_amount(amount)} on account #{account}" }

      return charge_failed(amount) if account.stripe_id.nil?

      charge = Stripe::Charge.create(
          amount: amount,
          currency: "usd",
          customer: account.stripe_id
      )

      transaction = account.add_payment(charge.amount, charge.fee, ::Accounts::CreditCard.from_card(charge.card), charge.id)
      mailer_service.payment_received(transaction: transaction)
      event_logger.with_entity(transaction).log(:payment_received)

      Rails.logger.info { "Payment successful" }

      if account.balance_favorable?
        automation_service.in_favor
      end

      true
    rescue Stripe::CardError => e
      Rails.logger.error { "Payment failed: #{e.message}" }

      charge_failed(amount)
    rescue Stripe::StripeError => e
      Airbrake.notify_or_ignore(e)

      Rails.logger.error { "Payment failed: #{e.message}" }
      e.backtrace.each { |line| Rails.logger.error line }

      charge_failed(amount)
    end

    private
    attr_reader :account, :mailer_service, :event_logger, :automation_service

    def charge_failed(amount)
      mailer_service.payment_failed(amount: amount)
      event_logger.log(:payment_failed)

      false
    end
  end
end