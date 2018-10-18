module Accounts
  class PaymentForm
    include ActiveModel::Model

    validates :amount_dollars, numericality: { greater_than_or_equal_to: 10 }, presence: true

    def amount
      @amount || 0
    end

    def amount_dollars
      amount / 100.0
    end

    def amount_dollars=(amount_dollars)
      @amount = (BigDecimal.new(amount_dollars) * 100).to_i
    end
  end
end