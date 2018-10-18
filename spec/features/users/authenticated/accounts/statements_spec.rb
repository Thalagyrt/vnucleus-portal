require 'spec_helper'

feature 'users/authenticated/accounts/statements' do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature 'user views statement' do
    given!(:transactions) { 5.times.map { create :transaction, account: account } }
    given!(:statement_id) { transactions.first.created_at.strftime("%Y-%m") }

    scenario do
      visit users_account_statement_path(account, statement_id)

      transactions.each do |transaction|
        expect(page).to have_content(transaction.reference)
      end
    end
  end

  feature 'user views statements' do
    given!(:transactions) { 5.times.map { create :transaction, account: account } }
    given!(:statement_name) { transactions.first.created_at.strftime("%B %Y") }

    scenario do
      visit users_account_statements_path(account)

      expect(page).to have_content(statement_name)
    end
  end
end