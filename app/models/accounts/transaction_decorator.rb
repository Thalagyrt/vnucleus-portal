module Accounts
  class TransactionDecorator < ApplicationDecorator
    include ::Concerns::TimestampDecoratorConcern

    decorates_association :account

    delegate_all

    def render_absolute_amount
      MoneyFormatter.format_amount(object.amount.abs)
    end

    def render_amount
      h.content_tag :span, data: { raw: amount } do
        render_amount_plaintext
      end
    end

    def render_amount_plaintext
      MoneyFormatter.format_amount(object.amount)
    end

    def render_fee
      h.content_tag :span, data: { raw: fee.to_i } do
        if fee
          MoneyFormatter.format_amount(object.fee)
        else
          "N/A"
        end
      end
    end

    def tr_class
      if object.amount > 0
        "danger"
      else
        "success"
      end
    end
  end
end