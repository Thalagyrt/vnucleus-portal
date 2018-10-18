require 'spec_helper'

feature "admin/accounts" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views accounts", js: true do
    given!(:accounts) { 3.times.map { create :account } }

    scenario do
      visit admin_accounts_path

      accounts.each do |account|
        expect(page).to have_content(account.name)
      end
    end
  end
end