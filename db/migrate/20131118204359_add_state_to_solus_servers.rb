class AddStateToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :state, :string
    add_index :solus_servers, :state
  end
end
