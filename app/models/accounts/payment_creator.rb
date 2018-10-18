module Accounts
  class PaymentCreator
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @event_logger = opts.fetch(:event_logger) { EventLogger.new(account: account) }
      @payment_service = opts.fetch(:payment_service) { PaymentService.new(account: account, event_logger: event_logger) }
    end

    def create(params)
      payment_form = PaymentForm.new(params)

      if payment_form.valid?
        if payment_service.charge(payment_form.amount)
          return publish(:create_success)
        else
          payment_form.errors.add(:amount_dollars, :declined)
        end
      end

      publish(:create_failure, payment_form)
    end

    private
    attr_reader :account, :event_logger, :payment_service
  end
end