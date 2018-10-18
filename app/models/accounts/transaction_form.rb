module Accounts
  class TransactionForm
    include ActiveModel::Model

    attr_accessor :amount, :description

    validates :description, presence: true
    validates :amount, presence: true, numericality: { greater_than: 0 }

    def amount_dollars
      amount / 100.0 if amount
    end

    def amount_dollars=(value)
      self.amount = BigDecimal.new(value) * 100 if value.present?
    end
  end
end