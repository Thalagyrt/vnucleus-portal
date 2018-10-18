require 'spec_helper'

feature 'users/authenticated/one time passwords/enables' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  feature 'user adds a one time password' do
    scenario do
      visit new_users_one_time_passwords_enables_path

      secret = find("#enable_form_otp_secret", visible: false).value

      fill_in 'enable_form_otp', with: totp_password(secret)

      click_button 'enable_form_submit'

      expect(page).to have_content('Authenticator has been enabled.')
    end

    scenario "with the wrong one time password" do
      visit new_users_one_time_passwords_enables_path

      fill_in 'enable_form_otp', with: '123'

      click_button 'enable_form_submit'

      expect(page).to have_content('invalid')
    end

    def totp_password(secret)
      ROTP::TOTP.new(secret).now
    end
  end
end