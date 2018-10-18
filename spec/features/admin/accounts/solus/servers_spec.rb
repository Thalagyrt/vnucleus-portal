require 'spec_helper'

feature 'admin/accounts/solus/servers' do
  given!(:user) { create :staff_user }
  given!(:account) { create :account }

  background { sign_in user }

  feature "lifecycle" do
    feature "admin adds a new server", js: true do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { create :solus_node, cluster: cluster }
      given!(:plan) { create :solus_plan, managed: true}
      given!(:template) { create :solus_template }

      before { cluster.plans << plan }
      before { plan.templates << template }

      scenario do
        visit new_admin_account_solus_server_path(account)

        fill_in 'server_form_hostname', with: 'test.betaforce.com'
        choose "server_form_cluster_id_#{cluster.id}"
        choose "server_form_managed_true"
        choose "server_form_plan_id_#{plan.id}"
        choose "server_form_template_id_#{template.id}"

        click_button 'server_form_submit'

        expect(page).to have_content('test.betaforce.com')
      end

      scenario "with invalid information" do
        visit new_admin_account_solus_server_path(account)

        fill_in 'server_form_hostname', with: ''
        choose "server_form_cluster_id_#{cluster.id}"
        choose "server_form_managed_true"
        choose "server_form_plan_id_#{plan.id}"
        choose "server_form_template_id_#{template.id}"

        click_button 'server_form_submit'

        expect(page).to have_content('This field is required.')
      end
    end

    feature "admin suspends server" do
      given!(:server) { create :solus_server, account: account, state: :active }

      background do
        stub_server_state :online
        stub_solus_request('vserver-suspend', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit admin_account_solus_server_suspensions_path(account, server)

        click_button 'server_suspend'

        expect(page).to have_content('Server suspended.')
      end
    end

    feature "admin unsuspends server" do
      given!(:server) { create :solus_server, account: account, state: :automation_suspended }

      background do
        stub_server_state :suspended
        stub_solus_request('vserver-unsuspend', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit admin_account_solus_server_unsuspensions_path(account, server)

        click_link 'server_unsuspend'

        expect(page).to have_content('Server unsuspended.')
      end
    end

    feature "admin terminates server" do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { cluster.nodes.create(allocated_ram: 700.megabytes, ram_limit: 1400.megabytes, available_disk: 40.gigabytes) }
      given!(:server) { create :solus_server, cluster: cluster, node: node, account: account, state: :admin_suspended }

      background do
        stub_solus_request('vserver-checkexists', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('vserver-terminate', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('listnodes', { type: 'xen' }, double(success?: true, nodes: 'Xen1'))
        stub_solus_request('listnodes', { type: 'kvm' }, double(success?: true, nodes: 'SSD1'))
        stub_solus_request('node-statistics', anything, double(:node_response, success?: true, hostname: 'Xen1', ip: '10.0.0.1',
                                                               memorylimit: 1400.megabytes, allocatedmemory: 800.megabytes, nodegroupname: 'HDD',
                                                               freedisk: 30.gigabytes, disklimit: 3.terabytes, freeips: 4, freeipv6: 400))
      end

      scenario do
        visit new_admin_account_solus_server_terminations_path(account, server)

        fill_in 'server_termination_reason', with: 'Testing Termination'
        click_button 'server_terminate'

        expect(page).to have_content('Testing Termination')
        expect(page).to have_content('Server queued for termination.')
      end
    end
  end

  feature "power control" do
    given!(:server) { create :solus_server, account: account, state: :active }

    feature "admin boots a server", js: true do
      background do
        stub_server_state :offline
        stub_solus_request('vserver-boot', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit admin_account_solus_server_path(account, server)

        click_link 'server_boot'

        click_button 'Boot'

        expect(page).to have_content('Server booted.')
      end
    end

    feature "admin reboots a server", js: true do
      background do
        stub_server_state :online
        stub_solus_request('vserver-reboot', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit admin_account_solus_server_path(account, server)

        click_link 'server_reboot'

        click_button 'Reboot'

        expect(page).to have_content('Server rebooted.')
      end
    end

    feature "admin shuts down a server", js: true do
      background do
        stub_server_state :online
        stub_solus_request('vserver-shutdown', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit admin_account_solus_server_path(account, server)

        click_link 'server_shutdown'

        click_button 'Shut Down'

        expect(page).to have_content('Server shut down.')
      end
    end
  end

  feature "admin views server", js: true do
    context "when the server is provisioning" do
      given!(:server) { create :solus_server, account: account, state: :pending_provision }

      scenario do
        visit admin_account_solus_server_path(account, server)

        expect(page).to have_content("Provisioning Server...")
      end
    end

    context "when the server is active" do
      given!(:server) { create :solus_server, account: account, state: :active }

      context "and online" do
        background do
          stub_server_state :online
        end

        scenario do
          visit admin_account_solus_server_path(account, server)

          expect(page).to have_content(server.hostname)
          expect(page).to have_content(server.template_name)
          expect(page).to have_content(server.plan_name)

          expect(page).to have_link('server_reboot')
          expect(page).to have_link('server_shutdown')
          expect(page).to have_link('server_suspend')

          expect(page).to_not have_link('server_boot')
        end
      end

      context "and offline" do
        background do
          stub_server_state :offline
        end

        scenario do
          visit admin_account_solus_server_path(account, server)

          expect(page).to have_content(server.hostname)
          expect(page).to have_content(server.template_name)
          expect(page).to have_content(server.plan_name)

          expect(page).to have_link('server_boot')
          expect(page).to have_link('server_suspend')

          expect(page).to_not have_link('server_reboot')
          expect(page).to_not have_link('server_shutdown')
        end
      end
    end
  end

  feature "admin views server root password", js: true do
    given!(:server) { create :solus_server, account: account, state: :active }

    background do
      stub_server_state :online
    end

    scenario do
      visit admin_account_solus_server_path(account, server)

      click_link("show_password")

      expect(page).to have_content(server.root_password)
    end
  end

  feature "admin views account server list" do
    given!(:servers) { 3.times.map { create :solus_server, account: account } }

    scenario do
      visit admin_account_solus_servers_path(account)

      servers.each do |server|
        expect(page).to have_content(server.hostname)
        expect(page).to have_content(server.template_name)
        expect(page).to have_content(server.plan_name)
      end
    end
  end

  feature "admin updates server" do
    given!(:server) { create :solus_server, account: account }

    scenario do
      visit edit_admin_account_solus_server_path(account, server)

      fill_in 'server_hostname', with: 'test.betaforce.com'
      fill_in 'server_plan_amount_dollars', with: '3.95'

      click_button 'server_submit'

      expect(page).to have_content('$3.95')
      expect(page).to have_content('test.betaforce.com')
    end

    scenario "with invalid information" do
      visit edit_admin_account_solus_server_path(account, server)

      fill_in 'server_hostname', with: ''

      click_button 'server_submit'

      expect(page).to have_content("is not a valid hostname")
    end
  end

  def stub_server_state(state)
    stub_solus_request('vserver-infoall', {vserverid: server.vserver_id},
                       double(success?: true, state: state.to_s, ipaddresses: '10.0.0.2', node: 'Xen1', bandwidth: '1024,256,768,25', hdd: '1024,0,0,0'))
    stub_solus_request('vserver-info', {vserverid: server.vserver_id},
                       double(success?: true, 'ctid_xid' => 'vm0'))
  end
end