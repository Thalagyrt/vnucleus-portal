class AddXenIdToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :xen_id, :string
  end
end
