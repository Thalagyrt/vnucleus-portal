require 'spec_helper'

feature 'admin/accounts/tickets/tickets' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature "admin views support tickets", js: true do
    given!(:tickets) { 3.times.map { create :ticket, account: account } }

    scenario do
      visit admin_account_tickets_path(account)

      tickets.each do |ticket|
        expect(page).to have_content(ticket.subject)
      end
    end
  end

  feature "admin views support ticket", js: true do
    given!(:ticket) { create :ticket, account: account }

    background do
      3.times { create :ticket_update, ticket: ticket }
    end

    scenario do
      visit admin_account_ticket_path(account, ticket)

      expect(page).to have_content(ticket.subject)

      ticket.updates.each do |update|
        expect(page).to have_content(update.body)
      end
    end
  end

  feature "admin submits new support ticket",  js: true do
    scenario do
      visit new_admin_account_ticket_path(account)

      fill_in 'ticket_form_subject', with: 'My stuff is borked.'
      fill_in 'ticket_form_body', with: 'Help me fix it?'
      click_button 'ticket_form_submit'

      expect(page).to have_content('My stuff is borked.')
      expect(page).to have_content('Help me fix it?')
    end
  end

  feature "admin closes support ticket", js: true do
    given!(:ticket) { create :ticket, account: account }

    background do
      create :ticket_update, ticket: ticket, user: user, status: :open, body: 'Halp.'
    end

    scenario do
      visit admin_account_ticket_path(account, ticket)

      click_button 'update_close'

      expect(page).to have_content('Closed')
    end
  end

  feature "admin reopens support ticket", js: true do
    given!(:ticket) { create :ticket, account: account, status: :closed }

    background do
      create :ticket_update, ticket: ticket, user: user, status: :closed
    end

    scenario do
      visit admin_account_ticket_path(account, ticket)

      click_button 'update_reopen'

      expect(page).to have_content('Open')
    end
  end

  feature "admin replies to an open support ticket", js: true do
    given!(:ticket) { create :ticket, account: account }

    background do
      create :ticket_update, ticket: ticket, user: user, status: :open, body: 'Halp.'
    end

    scenario do
      visit admin_account_ticket_path(account, ticket)

      fill_in 'update_body', with: 'Woohoo, an update!'
      click_button 'update_submit'

      expect(page).to have_content('Woohoo, an update!')
    end

    scenario "without a body" do
      visit admin_account_ticket_path(account, ticket)

      click_button 'update_submit'

      expect(page).to have_content("can't be blank")
    end
  end

  feature "admin replies to a closed support ticket", js: true do
    given!(:ticket) { create :ticket, account: account, status: :closed }

    background do
      create :ticket_update, ticket: ticket, user: user, status: :closed, body: 'Halp.'
    end

    scenario do
      visit admin_account_ticket_path(account, ticket)

      fill_in 'update_body', with: 'Woohoo, an update!'
      click_button 'update_leave_closed'

      expect(page).to have_content('Woohoo, an update!')
    end

    scenario "without a body" do
      visit admin_account_ticket_path(account, ticket)

      click_button 'update_leave_closed'

      expect(page).to have_content("can't be blank")
    end
  end

  feature "admin changes ticket priority", js: true do
    given!(:ticket) { create :ticket, account: account }
    given!(:update) { create :ticket_update, ticket: ticket, user: user, status: :open, body: 'Halp.' }

    scenario "to normal" do
      ticket.update_attributes priority: :critical
      update.update_attributes priority: :critical

      visit admin_account_ticket_path(account, ticket)

      fill_in 'update_body', with: 'Changing Status'
      select_chosen 'Normal', from: 'Priority'

      click_button 'update_submit'

      expect(find('#ticket_priority')).to have_content('Normal')
    end

    scenario "to critical" do
      visit admin_account_ticket_path(account, ticket)

      fill_in 'update_body', with: 'Changing Status'
      select_chosen 'Critical', from: 'Priority'

      click_button 'update_submit'

      expect(find('#ticket_priority')).to have_content('Critical')
    end
  end
end