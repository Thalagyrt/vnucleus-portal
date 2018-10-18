require 'spec_helper'

feature 'users/authenticated/accounts/events' do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature "user views events" do
    given!(:events) { [ create(:event, account: account), create(:event_server, account: account), create(:event_transaction, account: account), create(:event_ticket, account: account), create(:event_invite, account: account) ] }

    scenario do
      visit users_account_events_path(account)

      events.each do |event|
        expect(page).to have_content(event.message)
      end
    end
  end
end