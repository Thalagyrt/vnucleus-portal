require 'spec_helper'

feature 'users/authenticated/accounts/memberships' do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature "user views memberships" do
    given!(:memberships) { 3.times.map { create :membership, account: account } }

    scenario do
      visit users_account_memberships_path(account)

      memberships.each do |membership|
        expect(page).to have_content(membership.user.full_name)
      end
    end
  end

  feature "user removes membership" do
    given!(:membership) { create :membership, account: account }

    scenario do
      visit users_account_memberships_path(account)

      click_link "destroy_membership_#{membership.id}"

      expect(page).to_not have_content(membership.user.full_name)
    end
  end

  feature "user edits a membership" do
    given!(:membership) { create :membership, account: account }

    scenario do
      visit edit_users_account_membership_path(account, membership)

      uncheck 'membership_roles_full_control'
      check 'membership_roles_manage_billing'
      click_button 'membership_submit'

      expect(page).to have_content('Manage Billing')
    end
  end
end