require 'spec_helper'

feature 'users/authenticated/accounts' do
  given!(:user) { create :user_with_account }
  given(:account) { user.accounts.first }

  background { sign_in user }

  feature 'user views their accounts' do
    given!(:accounts) { 3.times.map { create :account } }

    background do
      accounts.each do |account|
        user.account_memberships.create(account: account, roles: [:full_control])
      end
    end

    scenario 'successfully' do
      visit users_accounts_path

      accounts.each do |account|
        expect(page).to have_content(account.name)
      end
    end
  end

  feature "alerts" do
    context "when the account has a balance due" do
      background do
        create :transaction, account: account, amount: 1000
      end

      scenario do
        visit users_account_path(account)

        expect(page).to have_content "Your account has an outstanding balance of $10.00."
      end
    end

    context "when the account has an expiring credit card" do
      background do
        account.update_attribute :stripe_expiration_date, Time.zone.today + 1.month
      end

      scenario do
        visit users_account_path(account)

        expect(page).to have_content "Your credit card expires on"
        expect(page).to have_link "Update Billing Information"
      end
    end

    context "when the account has an expired credit card" do
      background do
        account.update_attribute :stripe_expiration_date, Time.zone.today - 1.month
      end

      scenario do
        visit users_account_path(account)

        expect(page).to have_content "Your billing information is out of date"
        expect(page).to have_link "Update Billing Information"
      end
    end
  end
end