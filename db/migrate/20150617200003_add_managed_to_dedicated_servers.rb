class AddManagedToDedicatedServers < ActiveRecord::Migration
  def change
    add_column :dedicated_servers, :managed, :boolean, default: false
  end
end
