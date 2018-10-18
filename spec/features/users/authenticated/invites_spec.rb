require 'spec_helper'

feature 'users/authenticated/invites' do
  given!(:account) { create :account }
  given!(:invite) { create :invite, account: account }

  context "when the user is already registered" do
    given!(:user) { create :user }

    context "and signed in" do
      background { sign_in user }

      scenario do
        accept_invite

        expect(page).to have_content("Your invitation has been accepted.")
      end
    end

    context "but not signed in" do
      scenario do
        accept_invite

        click_link 'new_session'

        fill_in 'session_form_email', with: user.email
        fill_in 'session_form_password', with: user.password
        click_button 'session_form_submit'

        expect(page).to have_content("Your invitation has been accepted.")
      end
    end
  end

  context "when the user is not registered" do
    scenario do
      accept_invite

      fill_in 'user_form_email', with: 'derpybogsworth@betaforce.com'
      fill_in 'user_form_password', with: StringGenerator.password

      click_button 'user_form_submit'

      expect(page).to have_content("Your invitation has been accepted.")
    end
  end

  def accept_invite
    visit users_invites_path(token: invite.token)
  end
end