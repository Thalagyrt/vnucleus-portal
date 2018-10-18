require 'spec_helper'

feature "admin/solus/templates" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views templates" do
    given!(:templates) { 3.times.map { create(:solus_template) } }

    scenario do
      visit admin_solus_templates_path

      templates.each do |template|
        expect(page).to have_content(template.name)
      end
    end
  end

  feature "admin adds template" do
    scenario do
      visit new_admin_solus_template_path

      fill_in 'template_name', with: 'OS 1337'
      fill_in 'template_template', with: 'os_1337_x86_512_omg'
      fill_in 'template_plan_part', with: 'PV'
      fill_in 'template_virtualization_type', with: 'xen'
      fill_in 'template_root_username', with: 'root'
      fill_in 'template_description', with: "It's 1337er than you!"
      select 'Active', from: 'template_status'

      click_button 'template_submit'

      expect(page).to have_content('The template has been saved.')
    end
  end

  feature "admin edits template" do
    given!(:template) { create :solus_template }

    scenario do
      visit edit_admin_solus_template_path(template)

      fill_in 'template_name', with: 'OS 1337'

      click_button 'template_submit'

      expect(page).to have_content('The template has been updated.')
      expect(page).to have_content('OS 1337')
      expect(page).to_not have_content(template.name)
    end
  end
end