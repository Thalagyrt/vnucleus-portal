class AddProvisionIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :provision_id, :string
  end
end
