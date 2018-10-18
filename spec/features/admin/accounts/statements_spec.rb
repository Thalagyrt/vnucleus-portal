require 'spec_helper'

feature 'admin/accounts/statements' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature 'admin views statement' do
    given!(:transactions) { 5.times.map { create :transaction, account: account } }
    given!(:statement_id) { transactions.first.created_at.strftime("%Y-%m") }

    scenario do
      visit admin_account_statement_path(account, statement_id)

      transactions.each do |transaction|
        expect(page).to have_content(transaction.reference)
      end
    end
  end

  feature 'admin views statements' do
    given!(:transactions) { 5.times.map { create :transaction, account: account } }
    given!(:statement_name) { transactions.first.created_at.strftime("%B %Y") }

    scenario do
      visit admin_account_statements_path(account)

      expect(page).to have_content(statement_name)
    end
  end
end