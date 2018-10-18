class AddIpAddressToAccountEvents < ActiveRecord::Migration
  def change
    add_column :account_events, :ip_address, :string
  end
end
