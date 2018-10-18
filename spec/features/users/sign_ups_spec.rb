require 'spec_helper'

feature 'users/sign_ups' do
  feature "user signs up" do
    let(:customer) { double(:customer, id: 'cus_123', active_card: nil) }
    let(:new_password) { StringGenerator.password }

    before { allow(Stripe::Customer).to receive(:retrieve).and_return(nil) }
    before { allow(Stripe::Customer).to receive(:create).and_return(customer) }

    scenario do
      visit new_users_sign_up_path

      fill_in :sign_up_form_email, with: "user@test.betaforce.com"
      fill_in :sign_up_form_password, with: new_password

      click_button :user_form_submit

      visit users_emails_confirmations_path(token: Users::User.first.email_token)

      click_link 'I Accept'

      click_link 'Update Profile'

      fill_in 'user_first_name', with: 'Derpy'
      fill_in 'user_last_name', with: 'Bogsworth'
      fill_in 'user_phone', with: '3108675309'

      fill_in 'user_current_password', with: new_password

      click_button 'user_submit'

      expect(page).to have_link('Update Billing Information')
    end
  end
end