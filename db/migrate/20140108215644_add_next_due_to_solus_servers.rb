class AddNextDueToSolusServers < ActiveRecord::Migration
  def change
    add_column :solus_servers, :next_due, :date
    add_index :solus_servers, :next_due
  end
end
