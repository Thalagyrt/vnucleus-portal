class AddManagedToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :managed, :boolean, default: false
  end
end
