require 'spec_helper'

feature 'users/authenticated/accounts/solus/servers' do
  given!(:user) { create :user_with_account }
  given!(:account) { user.accounts.first }

  background { sign_in user }

  feature "lifecycle" do
    feature "user orders a new server", js: true do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { create :solus_node, cluster: cluster }
      given!(:plan) { create :solus_plan, managed: true }
      given!(:template) { create :solus_template }

      before { cluster.plans << plan }
      before { plan.templates << template }

      scenario do
        visit new_users_account_solus_server_path(account)

        fill_in 'server_form_hostname', with: 'test.betaforce.com'
        choose "server_form_cluster_id_#{cluster.id}"
        choose "server_form_managed_true"
        choose "server_form_plan_id_#{plan.id}"
        choose "server_form_template_id_#{template.id}"

        click_button 'server_form_submit'

        expect(page).to have_content('Confirm Server')
      end

      scenario "with a coupon code" do
        coupon = Orders::Coupon.create(coupon_code: 'test', factor: 0.9, status: :active)

        visit new_users_account_solus_server_path(account)

        fill_in 'server_form_hostname', with: 'test.betaforce.com'
        choose "server_form_cluster_id_#{cluster.id}"
        choose "server_form_managed_true"
        choose "server_form_plan_id_#{plan.id}"
        choose "server_form_template_id_#{template.id}"
        fill_in 'server_form_coupon_code', with: coupon.coupon_code

        click_button 'server_form_submit'

        expect(page).to have_content('Confirm Server')
      end

      scenario "with invalid information" do
        visit new_users_account_solus_server_path(account)

        fill_in 'server_form_hostname', with: ''
        choose "server_form_cluster_id_#{cluster.id}"
        choose "server_form_managed_true"
        choose "server_form_plan_id_#{plan.id}"
        choose "server_form_template_id_#{template.id}"

        click_button 'server_form_submit'

        expect(page).to have_content('This field is required')
      end
    end

    feature "user confirms a server order" do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { create :solus_node, cluster: cluster }
      given!(:template) { create :solus_template }
      given!(:plan) { create :solus_plan }
      given!(:server) { create :solus_server, cluster: cluster, template: template, account: account, state: :pending_confirmation, next_due: Time.zone.today + 1.month }
      given!(:card) { double(:card, type: 'Visa', last4: "4242").as_null_object }
      given!(:charge) { double(:charge, id: 'ch_123', amount: server.prorated_amount, fee: 50, card: card) }

      background do
        allow(Stripe::Charge).to receive(:create).and_return(charge)
        stub_solus_request('client-create', anything, double(success?: true))
        stub_solus_request('vserver-create', anything, double(success?: true, vserverid: 1, mainipaddress: '127.0.0.1', rootpassword: 'derp'))
        stub_solus_request('listnodes', { type: 'xen' }, double(success?: true, nodes: 'Xen1'))
        stub_solus_request('listnodes', { type: 'kvm' }, double(success?: true, nodes: 'SSD1'))
        stub_solus_request('node-statistics', anything, double(:node_response, success?: true, hostname: 'Xen1', ip: '10.0.0.1',
                                                               memorylimit: 1400.megabytes, allocatedmemory: 800.megabytes, nodegroupname: 'HDD',
                                                               freedisk: 30.gigabytes, disklimit: 3.terabytes, freeips: 4, freeipv6: 400))
        stub_solus_request('vserver-infoall', {vserverid: 1}, double(success?: true, state: 'online', node: 'Xen1', ipaddresses: '10.0.0.2', bandwidth: '1024,256,768,25', hdd: '1024,0,0,0'))
        stub_solus_request('vserver-info', {vserverid: 1}, double(success?: true, 'ctid_xid' => 'vm0'))
      end

      scenario do
        visit new_users_account_solus_server_confirmations_path(account, server)

        click_link 'server_confirm'

        expect(page).to have_content('Order submitted.')
        expect(server.reload.vserver_id).to eq(1)
      end
    end

    feature "user cancels a server order" do
      given!(:server) { create :solus_server, account: account, state: :pending_confirmation }

      scenario do
        visit new_users_account_solus_server_confirmations_path(account, server)

        click_link 'server_cancel'

        expect(page).to have_content('Your server order has been canceled.')
      end
    end

    feature "user terminates a server", js: true do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { create :solus_node, cluster: cluster }
      given!(:server) { create :solus_server, cluster: cluster, node: node, account: account, state: :active }

      background do
        stub_solus_request('vserver-checkexists', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('vserver-terminate', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('listnodes', { type: 'xen' }, double(success?: true, nodes: 'Xen1'))
        stub_solus_request('listnodes', { type: 'kvm' }, double(success?: true, nodes: 'SSD1'))
        stub_solus_request('node-statistics', anything, double(:node_response, success?: true, hostname: 'Xen1', ip: '10.0.0.1',
                                                               memorylimit: 1400.megabytes, allocatedmemory: 800.megabytes, nodegroupname: 'HDD',
                                                               freedisk: 30.gigabytes, disklimit: 3.terabytes, freeips: 4, freeipv6: 400))
        stub_solus_request('vserver-infoall', {vserverid: server.vserver_id}, double(success?: true, state: 'online', node: 'Xen1', ipaddresses: '10.0.0.2'))
        stub_solus_request('vserver-info', {vserverid: server.vserver_id}, double(success?: true, 'ctid_xid' => 'vm0'))
      end

      scenario do
        visit new_users_account_solus_server_terminations_path(account, server)

        fill_in 'server_termination_reason', with: 'Testing Termination'

        click_button 'server_terminate'

        within('.bootbox') do
          click_button 'Terminate'
        end

        expect(page).to have_content('Testing Termination')
        expect(page).to have_content('Server queued for termination.')
      end
    end

    feature "user reinstalls a server", js: true do
      given!(:cluster) { create :solus_cluster }
      given!(:node) { create :solus_node, cluster: cluster }
      given!(:plan) { create :solus_plan }
      given!(:template) { create :solus_template }
      given!(:server) { create :solus_server, cluster: cluster, template: template, node: node, plan: plan, account: account, state: :active }

      before { cluster.plans << plan }
      before { plan.templates << template }

      background do
        stub_solus_request('vserver-checkexists', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('vserver-terminate', {vserverid: server.vserver_id, deleteclient: true}, double(success?: true))
        stub_solus_request('client-create', anything, double(success?: true))
        stub_solus_request('vserver-create', anything, double(success?: true, vserverid: 1, mainipaddress: '127.0.0.1', rootpassword: 'derp'))
        stub_solus_request('listnodes', { type: 'xen' }, double(success?: true, nodes: 'Xen1'))
        stub_solus_request('listnodes', { type: 'kvm' }, double(success?: true, nodes: 'SSD1'))
        stub_solus_request('node-statistics', anything, double(:node_response, success?: true, hostname: 'Xen1', ip: '10.0.0.1',
                                                               memorylimit: 1400.megabytes, allocatedmemory: 800.megabytes, nodegroupname: 'HDD',
                                                               freedisk: 30.gigabytes, disklimit: 3.terabytes, freeips: 4, freeipv6: 400))
        stub_solus_request('vserver-infoall', {vserverid: 1}, double(success?: true, state: 'online', node: 'Xen1', ipaddresses: '10.0.0.2', bandwidth: '1024,256,768,25', hdd: '1024,0,0,0'))
        stub_solus_request('vserver-info', {vserverid: 1}, double(success?: true, 'ctid_xid' => 'vm0'))
      end

      scenario do
        visit new_users_account_solus_server_reinstalls_path(account, server)

        click_button 'server_reinstall'

        within('.bootbox') do
          click_button 'Reinstall'
        end

        expect(page).to have_content('Server queued for reinstall.')
      end
    end
  end

  feature "power control" do
    given!(:server) { create :solus_server, account: account, state: :active }

    feature "user boots a server", js: true do
      background do
        stub_server_state :offline
        stub_solus_request('vserver-boot', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit users_account_solus_server_path(account, server)

        click_link 'server_boot'

        click_button 'Boot'

        expect(page).to have_content('Server booted.')
      end
    end

    feature "user reboots a server", js: true do
      background do
        stub_server_state :online
        stub_solus_request('vserver-reboot', {vserverid: server.vserver_id}, double(success?: true))
      end

      scenario do
        visit users_account_solus_server_path(account, server)

        click_link 'server_reboot'

        click_button 'Reboot'

        expect(page).to have_content('Server rebooted.')
      end
    end

    feature "user shuts down a server", js: true do
      background do
        stub_server_state :online
        stub_solus_request('vserver-shutdown', {vserverid: server.vserver_id}, double(success?: true))
      end

      it do
        visit users_account_solus_server_path(account, server)

        click_link 'server_shutdown'

        click_button 'Shut Down'

        expect(page).to have_content('Server shut down.')
      end
    end
  end

  feature "user views server", js: true do
    context "when the server is provisioning" do
      given!(:server) { create :solus_server, account: account, state: :pending_provision }

      scenario do
        visit users_account_solus_server_path(account, server)

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
          visit users_account_solus_server_path(account, server)

          expect(page).to have_content(server.hostname)
          expect(page).to have_content(server.template_name)
          expect(page).to have_content(server.plan_name)

          expect(page).to have_link('server_reboot')
          expect(page).to have_link('server_shutdown')
          expect(page).to have_link('server_terminate')

          expect(page).to_not have_link('server_boot')
        end
      end

      context "and offline" do
        background do
          stub_server_state :offline
        end

        scenario do
          visit users_account_solus_server_path(account, server)

          expect(page).to have_content(server.hostname)
          expect(page).to have_content(server.template_name)
          expect(page).to have_content(server.plan_name)

          expect(page).to have_link('server_boot')
          expect(page).to have_link('server_terminate')

          expect(page).to_not have_link('server_reboot')
          expect(page).to_not have_link('server_shutdown')
        end
      end
    end
  end

  feature "user views server root password", js: true do
    given!(:server) { create :solus_server, account: account, state: :active }

    background do
      stub_server_state :online
    end

    it do
      visit users_account_solus_server_path(account, server)

      click_link("show_password")

      expect(page).to have_content(server.root_password)
    end
  end

  feature "user views server list" do
    given!(:servers) { 3.times.map { create :solus_server, account: account } }

    scenario do
      visit users_account_solus_servers_path(account)

      servers.each do |server|
        expect(page).to have_content(server.hostname)
        expect(page).to have_content(server.template_name)
        expect(page).to have_content(server.plan_name)
      end
    end
  end

  def stub_server_state(state)
    stub_solus_request('vserver-infoall', {vserverid: server.vserver_id},
                       double(success?: true, state: state.to_s, ipaddresses: '10.0.0.2', node: 'Xen1', bandwidth: '1024,256,768,25', hdd: '1024,0,0,0'))
    stub_solus_request('vserver-info', {vserverid: server.vserver_id}, double(success?: true, 'ctid_xid' => 'vm0'))
  end
end