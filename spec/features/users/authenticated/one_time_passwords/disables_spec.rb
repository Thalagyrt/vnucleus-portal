require 'spec_helper'

feature 'users/authenticated/one time passwords/disables' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  feature "user removes a one time password" do
    let(:user) { create :user, otp_secret: 'supersecretbase32' }

    scenario do
      visit new_users_one_time_passwords_disables_path

      fill_in 'disable_form_password', with: user.password

      click_button 'disable_form_submit'

      expect(page).to have_content('Authenticator has been disabled.')
    end

    scenario "with an invalid password" do
      visit new_users_one_time_passwords_disables_path

      fill_in 'disable_form_password', with: 'lol'

      click_button 'disable_form_submit'

      expect(page).to have_content('invalid')
    end

    def totp_password
      ROTP::TOTP.new(user.otp_secret).now
    end
  end
end