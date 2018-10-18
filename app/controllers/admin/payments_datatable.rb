module Admin
  class PaymentsDatatable
    include SimpleDatatable

    sort_columns %w[accounts_transactions.amount accounts_transactions.fee accounts_accounts.long_id accounts_transactions.created_at accounts_transactions.description accounts_transactions.reference]

    def render(transaction)
      {
          amount: transaction.render_amount,
          fee: transaction.render_fee,
          account_id: transaction.account.link_to_s(:admin),
          created_at: transaction.render_created_at,
          description: transaction.description,
          reference: transaction.reference,
      }
    end
  end
end