module Accounts
  class StatementDecorator < ApplicationDecorator
    delegate_all

    decorates_association :transactions

    def to_s
      if object.end_date > Time.zone.today
        "#{object.to_s} (Current)"
      else
        object.to_s
      end
    end

    def render_starting_balance
      MoneyFormatter.format_amount(object.starting_balance)
    end

    def render_ending_balance
      MoneyFormatter.format_amount(object.ending_balance)
    end

    def render_net_change
      MoneyFormatter.format_amount(object.net_change)
    end

    def net_change_class
      if object.net_change < 0
        'success'
      elsif object.net_change > 0
        'danger'
      else
        'info'
      end
    end

    def render_payments
      MoneyFormatter.format_amount(object.total_payments)
    end

    def render_refunds
      MoneyFormatter.format_amount(object.total_refunds)
    end

    def render_credits
      MoneyFormatter.format_amount(object.total_credits)
    end

    def render_referrals
      MoneyFormatter.format_amount(object.total_referrals)
    end

    def render_debits
      MoneyFormatter.format_amount(object.total_debits)
    end

    def render_total_debits
      MoneyFormatter.format_amount(object.total_category_debits)
    end

    def render_total_credits
      MoneyFormatter.format_amount(object.total_category_credits)
    end
  end
end