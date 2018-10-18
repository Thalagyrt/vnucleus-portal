require 'spec_helper'

feature "admin/solus/servers" do
  given!(:user) { create :staff_user }

  background { sign_in user }

  feature "admin views solus servers", js: true do
    given!(:servers) { 3.times.map { create :solus_server } }

    scenario do
      visit admin_solus_servers_path

      servers.each do |server|
        expect(page).to have_content(server.hostname)
      end
    end
  end
end