require 'spec_helper'

feature 'admin/accounts/events' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature "admin views events" do
    given!(:events) { [ create(:event, account: account), create(:event_server, account: account), create(:event_transaction, account: account), create(:event_ticket, account: account) ] }

    scenario do
      visit admin_account_events_path(account)

      events.each do |event|
        expect(page).to have_content(event.message)
      end
    end
  end
end