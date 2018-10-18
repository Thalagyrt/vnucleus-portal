module Admin
  class DashboardDecorator < ApplicationDecorator
    include ::Concerns::RamDecoratorConcern
    include ::Concerns::DiskDecoratorConcern

    delegate_all

    decorates_association :open_tickets
    decorates_association :accounts_pending_welcome
    decorates_association :accounts_pending_activation
    decorates_association :accounts_with_balance_owed
    decorates_association :online_users
    decorates_association :servers_pending_patches
    decorates_association :dedicated_servers_pending_action

    def render_income_this_year
      MoneyFormatter.format_amount(object.income_this_year)
    end

    def render_fees_this_year
      MoneyFormatter.format_amount(object.fees_this_year)
    end

    def render_monthly_rate
      MoneyFormatter.format_amount(object.monthly_rate)
    end
  end
end