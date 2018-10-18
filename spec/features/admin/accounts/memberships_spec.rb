require 'spec_helper'

feature "admin/accounts/memberships" do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature "admin views account memberships" do
    let!(:membership) { account.memberships.create(user: user, roles: :full_control) }

    scenario do
      visit admin_account_memberships_path(account)

      expect(page).to have_content(user.full_name)
      expect(page).to have_content("Full Control")
    end
  end
end