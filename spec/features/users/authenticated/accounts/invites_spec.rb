require 'spec_helper'

feature 'users/authenticated/accounts/invites' do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature "user views invites" do
    given!(:invites) { 3.times.map { create :invite, account: account } }

    scenario do
      visit users_account_invites_path(account)

      invites.each do |invite|
        expect(page).to have_content(invite.email)
      end
    end
  end

  feature "user disables invite" do
    given!(:invite) { create :invite, account: account }

    scenario do
      visit users_account_invites_path(account)

      click_link "remove_invite_#{invite.id}"

      expect(page).to_not have_content(invite.email)
    end
  end

  feature "user adds invite" do
    scenario do
      visit new_users_account_invite_path(account)

      fill_in "invite_email", with: 'flerpy@betaforce.com'

      click_button "invite_submit"

      expect(page).to have_content("flerpy@betaforce.com")
    end
  end
end