require 'spec_helper'

feature "admin/solus/plans" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views plans" do
    given!(:plans) { 3.times.map { create(:solus_plan) } }

    scenario do
      visit admin_solus_plans_path

      plans.each do |plan|
        expect(page).to have_content(plan.name)
      end
    end
  end

  feature "admin adds plan" do
    scenario do
      visit new_admin_solus_plan_path

      fill_in 'plan_name', with: 'VPS 9001'
      fill_in 'plan_ram_mb', with: '9001'
      fill_in 'plan_disk_gb', with: '9001'
      fill_in 'plan_disk_type', with: 'HDD'
      fill_in 'plan_transfer_tb', with: '9001'
      fill_in 'plan_ip_addresses', with: '9001'
      fill_in 'plan_ipv6_addresses', with: '9001'
      fill_in 'plan_vcpus', with: '9001'
      fill_in 'plan_plan_part', with: '9001'
      fill_in 'plan_network_out', with: '1000'
      fill_in 'plan_amount_dollars', with: '9001'
      select 'Active', from: 'plan_status'

      click_button 'plan_submit'

      expect(page).to have_content('The plan has been saved.')
    end
  end

  feature "admin edits plan" do
    given!(:plan) { create :solus_plan }

    scenario do
      visit edit_admin_solus_plan_path(plan)

      fill_in 'plan_name', with: 'VPS 9001'

      click_button 'plan_submit'

      expect(page).to have_content('The plan has been updated.')
      expect(page).to have_content('VPS 9001')
      expect(page).to_not have_content(plan.name)
    end
  end
end