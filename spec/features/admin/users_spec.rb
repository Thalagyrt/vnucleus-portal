require 'spec_helper'

feature "admin/users" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views a user" do
    scenario do
      visit admin_user_path(user)

      expect(page).to have_content(user.first_name)
      expect(page).to have_content(user.last_name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.phone)
    end
  end

  feature "admin views users" do
    given!(:users) { 5.times.map { create :user } }

    scenario do
      visit admin_users_path

      users.each do |user|
        expect(page).to have_content(user.first_name)
        expect(page).to have_content(user.last_name)
        expect(page).to have_content(user.email)
      end
    end
  end
end