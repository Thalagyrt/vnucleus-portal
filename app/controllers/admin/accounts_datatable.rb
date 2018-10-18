module Admin
  class AccountsDatatable
    include SimpleDatatable

    sort_columns %w[accounts_accounts.long_id accounts_accounts.name accounts_accounts.balance_cache accounts_accounts.monthly_rate_cache accounts_accounts.server_count_cache accounts_accounts.state]

    def render(object)
      {
          long_id: object.link_long_id(:admin),
          name: object.link_name(:admin),
          balance: object.render_balance,
          monthly_rate: object.render_monthly_rate,
          server_count: object.server_count,
          state: object.render_state,
      }
    end
  end
end