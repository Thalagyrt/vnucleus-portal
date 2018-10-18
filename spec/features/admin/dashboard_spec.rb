require 'spec_helper'

feature "admin/dashboard" do
  given!(:user)     { create :staff_user }
  given!(:cluster)  { create :solus_cluster }
  given!(:nodes)    { 3.times.map { create :solus_node, cluster: cluster, allocated_ram: 64.gigabytes, ram_limit: 128.gigabytes, available_disk: 4.terabytes, disk_limit: 8.terabytes } }
  given!(:account)  { create :account }
  given!(:server)   { create :solus_server, cluster: cluster, account: account, state: :active }
  given!(:payments) { 3.times.map { create :transaction_payment, account: account } }

  background { sign_in user }

  feature "admin views dashboard" do
    scenario do
      visit admin_dashboard_path

      expect(find('#node_health').find('#ram_utilization')).to have_content('50%')
      expect(find('#node_health').find('#disk_utilization')).to have_content('50%')
      expect(find('#node_health')).to have_content('192 GB')
      expect(find('#node_health')).to have_content('12 TB')

      expect(find('#financials')).to have_content(MoneyFormatter.format_amount(-payments.sum(&:amount)))
      expect(find('#financials')).to have_content(MoneyFormatter.format_amount(server.amount))
    end
  end
end