require 'spec_helper'

feature 'users/authenticated/profiles' do
  let!(:user) { create :user }

  background { sign_in user }

  feature 'user changes password' do
    given!(:new_password) { StringGenerator.password }

    scenario do
      change_password user.password, new_password

      should_log_back_in_with new_password
    end

    scenario 'with invalid data' do
      change_password new_password, new_password

      expect(current_path).to eq(users_profile_path)

      should_log_back_in_with user.password
    end

    scenario 'with an invalid new password' do
      change_password user.password, 'tootiny'

      expect(current_path).to eq(users_profile_path)

      should_log_back_in_with user.password
    end

    scenario 'with an invalid old password' do
      change_password 'wrongpassword', new_password

      expect(current_path).to eq(users_profile_path)

      should_log_back_in_with user.password
    end

    def should_log_back_in_with password
      sign_out
      form_based_sign_in user, password: password

      expect(page).to have_content(user.first_name)
    end

    def change_password(old_password, new_password)
      visit edit_users_profile_path

      fill_in 'user_current_password', with: old_password
      fill_in 'user_password', with: new_password
      fill_in 'user_password_confirmation', with: new_password

      click_button 'user_submit'
    end
  end

  feature 'user changes profile' do
    scenario do
      visit edit_users_profile_path

      fill_in 'user_security_question', with: 'Narfbarfl?'
      fill_in 'user_security_answer', with: 'Blargfarbl!'

      fill_in 'user_current_password', with: user.password
      click_button 'user_submit'

      expect(current_path).to eq(users_accounts_path)
    end

    scenario 'with invalid data' do
      visit edit_users_profile_path

      fill_in 'user_first_name', with: ''
      fill_in 'user_last_name', with: ''

      fill_in 'user_current_password', with: user.password
      click_button 'user_submit'

      expect(current_path).to eq(users_profile_path)
    end

    scenario 'with an invalid current password' do
      visit edit_users_profile_path

      fill_in 'user_current_password', with: 'flerpyderpy'
      click_button 'user_submit'

      expect(current_path).to eq(users_profile_path)
    end
  end
end