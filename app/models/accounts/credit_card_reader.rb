module Accounts
  class CreditCardReader
    include Wisper::Publisher

    def initialize(opts = {})
      @account = opts.fetch(:account)
      @stripe_card_service = opts.fetch(:stripe_card_service) { StripeCardService.new(account: account) }
    end

    def read
      if credit_card
        publish(:read_success, credit_card)
      else
        publish(:read_failure)
      end
    end

    private
    attr_reader :account, :stripe_card_service

    def credit_card
      @credit_card ||= stripe_card_service.fetch
    end
  end
end