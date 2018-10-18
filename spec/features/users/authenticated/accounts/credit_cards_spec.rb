require 'spec_helper'

feature "users/authenticated/accounts/credit cards" do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature "user views credit card" do
    given(:credit_card) { double(:credit_card, name: 'Derpy Bogsworth', last4: '4242', type: 'Visa', exp_month: '01', exp_year: Time.zone.today.year + 1).as_null_object }
    given(:customer) { double(:customer, active_card: credit_card) }

    background do
      allow(Stripe::Customer).to receive(:retrieve).and_return(customer)
    end


    scenario do
      visit users_account_credit_cards_path(account)

      expect(page).to have_content(credit_card.name)
      expect(page).to have_content(credit_card.last4)
      expect(page).to have_content(credit_card.type)
    end
  end
end