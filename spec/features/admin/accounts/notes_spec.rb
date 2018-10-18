require 'spec_helper'

feature 'admin/accounts/notes' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature 'admin adds a note to an account' do
    scenario do
      visit admin_account_notes_path(account)

      fill_in :note_body, with: 'This is a test note.'
      click_button :note_submit

      expect(page).to have_content('The note has been added.')
      expect(page).to have_content('This is a test note.')
    end
  end
end