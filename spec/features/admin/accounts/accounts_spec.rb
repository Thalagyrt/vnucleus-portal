require 'spec_helper'

feature "admin/accounts/accounts" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views account" do
    given!(:account) { create :account }

    scenario do
      visit admin_account_path(account)

      expect(page).to have_content(account.name)
    end
  end
end