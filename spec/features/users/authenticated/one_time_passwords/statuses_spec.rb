require 'spec_helper'

feature 'users/authenticated/one time passwords/statuses' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  feature 'user views one time password status' do
    context "when one time passwords are enabled" do
      let(:user) { create :user, otp_secret: 'supersecretbase32' }

      scenario do
        visit users_one_time_passwords_statuses_path

        expect(page).to have_content('Enabled')
      end
    end

    context "when one time passwords are disabled" do
      scenario do
        visit users_one_time_passwords_statuses_path

        expect(page).to have_content('Disabled')
      end
    end
  end
end