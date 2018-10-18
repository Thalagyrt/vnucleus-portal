require 'spec_helper'

feature "admin/tickets" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views support tickets", js: true do
    given!(:tickets) { 3.times.map { create :ticket } }

    scenario do
      visit admin_tickets_path

      tickets.each do |ticket|
        expect(page).to have_content(ticket.subject)
      end
    end
  end
end