require 'spec_helper'

feature "admin/analytics" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views analytics" do
    scenario do
      visit admin_analytics_path

      expect(page).to have_content('Analytics')
    end
  end
end