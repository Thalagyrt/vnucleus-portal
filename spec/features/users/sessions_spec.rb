require 'spec_helper'

feature 'users/sessions' do
  let!(:user) { create :user }

  feature 'user signs in' do
    scenario do
      form_based_sign_in user

      expect(page).to have_content(user.first_name)
    end

    scenario 'with invalid credentials' do
      form_based_sign_in user, password: 'lol'

      expect(page).to have_content('Sign In')
    end

    scenario 'with missing credentials' do
      form_based_sign_in user, email: ''

      expect(page).to have_content('Sign In')
    end

    context "when a one time password is required" do
      given!(:user) { create :user, otp_secret: 'supersecretbase32' }

      scenario do
        form_based_sign_in user

        expect(page).to have_content(user.first_name)
      end

      scenario "with an incorrect one time password" do
        form_based_sign_in user, otp: '123'

        expect(page).to have_content('Sign In')
      end
    end

    context "when the user's IP address is not known" do
      background { user.update_attributes enhanced_security: true }

      scenario do
        form_based_sign_in user

        expect(page).to have_content(user.first_name)
      end

      scenario "with an incorrect authorization code" do
        form_based_sign_in user, authorization_code: '123'

        expect(page).to have_content('Authorize')
      end
    end
  end

  feature 'user signs out' do
    background { form_based_sign_in user }

    scenario do
      form_based_sign_out

      expect(page).to have_content('Sign In')
    end
  end
end